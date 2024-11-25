//
//  CoreDataService.swift
//  TechnicalTask-lvl1
//
//  Created by Сергей Матвеенко on 25.11.24.
//

import Foundation
import CoreData

final class CoreDataService: CoreDataServiceProtocol {
    
    // MARK: - Parameters
    
    private lazy var coreDataStack: CoreDataStack = {
        CoreDataStack(modelName: CoreDataStrings.modelName)
    }()
    
    // MARK: - Persistence methods
    
    func fetchUsers() async throws -> [NSManagedObject] {
        let managedContext = self.coreDataStack.managedContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: CoreDataStrings.entityName)
        var users = [NSManagedObject]()
        
        do {
            users = try managedContext.fetch(fetchRequest)
        }
        
        catch let error as NSError {
            throw error
        }
        
        return users
    }
    
    func saveUser(_ user: UserModel) async throws {
        let managedContext = self.coreDataStack.managedContext
        guard let entity = NSEntityDescription.entity(forEntityName: CoreDataStrings.entityName, in: managedContext) else { return }
        let newUser = NSManagedObject(entity: entity, insertInto: managedContext)
        newUser.setValue(user.username, forKey: CoreDataStrings.attributeUserName)
        newUser.setValue(user.email, forKey: CoreDataStrings.attributeEmail)
        newUser.setValue(user.address.city, forKey: CoreDataStrings.attributeCity)
        newUser.setValue(user.address.street, forKey: CoreDataStrings.attributeStreet)
        
        do {
            try managedContext.save()
        }
        
        catch let error as NSError {
            throw error
        }
    }
}
