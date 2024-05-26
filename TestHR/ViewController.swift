//
//  ViewController.swift
//  TestHR
//
//  Created by Nikola Ilic on 26.5.24..
//

import UIKit

class ViewController: UIViewController {
    
    let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Username"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .gray
        textField.textColor = .white
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .gray
        textField.textColor = .white
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.backgroundColor = .gray
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(usernameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        
        setupConstraints()
        
        
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)

    }
    
    @objc func loginButtonTapped() {
        let email = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        if validatePassword(password) {
            performLogin(email: email, password: password)
        } else {
            let alert = UIAlertController(title: "Error", message: "Invalid email or password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    


    func performLogin(email: String, password: String) {
        print("Attempting login with email: \(email) and password: \(password)")
        let loginEndpoint = "https://api-assigment.eaglelab.com/v1/login"
        guard let url = URL(string: loginEndpoint) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let loginRequest = LoginRequest(email: email, password: password)
        
        do {
            let jsonData = try JSONEncoder().encode(loginRequest)
            request.httpBody = jsonData
        } catch {
            print("Error encoding login request: \(error)")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }
            
            print("Response status code: \(httpResponse.statusCode)")
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                print("Login successful! Token: \(loginResponse.token)")
                DispatchQueue.main.async {
                    print("Navigating to HomeViewController")
                    UserDefaults.standard.set(loginResponse.token, forKey: "authToken")
                    let homeViewController = HomeViewController()
                    UIApplication.shared.windows.first?.rootViewController = homeViewController
                    UIApplication.shared.windows.first?.makeKeyAndVisible()
                }


            } catch {
                print("JSON parsing error: \(error)")
            }
        }
        task.resume()
    }
    
   
    
    func validatePassword(_ password: String) -> Bool {
        return password.count >= 8
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            usernameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            usernameTextField.widthAnchor.constraint(equalToConstant: 250),
            
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 20),
            passwordTextField.widthAnchor.constraint(equalToConstant: 250),
            
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20)
        ])
    }
}

