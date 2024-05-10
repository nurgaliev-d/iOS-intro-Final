//
//  AuthStorage.swift
//  Events
//
//  Created by Nurasyl Melsuly on 10.05.2024.
//

import Foundation

class AuthStorage {
    static var shared = AuthStorage()

    private let defaults = UserDefaults.standard

    var token: String? {
        get {
            defaults.string(forKey: "token")
        }
        set {
            defaults.setValue(newValue, forKey: "token")
        }
    }

    var currentUser: User? {
        get {
            let decoder = JSONDecoder()
            if let data = defaults.data(forKey: "currentUser") {
                return try? decoder.decode(User.self, from: data)
            }
            return nil
        }
        set {
            let encoder = JSONEncoder()
            let data = try? encoder.encode(newValue)
            defaults.setValue(data, forKey: "currentUser")
        }
    }

    private init() {}
}
