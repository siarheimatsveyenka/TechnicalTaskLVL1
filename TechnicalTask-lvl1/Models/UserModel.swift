//
//  UserModel.swift
//  TechnicalTask-lvl1
//
//  Created by Сергей Матвеенко on 25.11.24.
//

import Foundation

struct UserModel: Codable {
    let username: String
    let email: String
    let address: Address
}

struct Address: Codable {
    let city: String
    let street: String
}
