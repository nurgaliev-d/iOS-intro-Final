//
//  AuthResponse.swift
//  Events
//
//  Created by Nurasyl Melsuly on 10.05.2024.
//

import Foundation

struct AuthResponse: Decodable {
    let token: String
    let user: User

    enum CodingKeys: String, CodingKey {
        case token = "Access-token"
        case user = "User"
    }
}
