//
//  Model.swift
//  TestHR
//
//  Created by Nikola Ilic on 26.5.24..
//
import Foundation

struct LoginRequest: Codable {
    let email: String
    let password: String
}

struct LoginResponse: Codable {
    let firstName: String
    let id: Int
    let lastName: String
    let token: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case id
        case lastName = "last_name"
        case token
    }
}

