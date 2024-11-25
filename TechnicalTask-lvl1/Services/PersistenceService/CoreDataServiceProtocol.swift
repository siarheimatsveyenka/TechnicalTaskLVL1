//
//  CoreDataServiceProtocol.swift
//  TechnicalTask-lvl1
//
//  Created by Сергей Матвеенко on 25.11.24.
//

import Foundation
import CoreData

protocol CoreDataServiceProtocol {
    func fetchUsers() async throws -> [NSManagedObject]
    func saveUser(_ user: UserModel) async throws
}
