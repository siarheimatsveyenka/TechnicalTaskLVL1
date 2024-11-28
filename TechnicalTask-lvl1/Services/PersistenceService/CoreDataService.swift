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
    
    private var coreDataStack: CoreDataStack = {
        CoreDataStack(modelName: CoreDataStrings.modelName)
    }()
    
    private var managedContext: NSManagedObjectContext {
        self.coreDataStack.managedContext
    }
    
    
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
        guard let entity = NSEntityDescription.entity(forEntityName: CoreDataStrings.entityName, in: self.managedContext) else { return }
        let newUser = NSManagedObject(entity: entity, insertInto: self.managedContext)
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
    
    func deleteUser(_ user: UsersListDiplayModel) throws {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: CoreDataStrings.entityName)
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "\(CoreDataStrings.attributeUserName) == %@", user.username),
            NSPredicate(format: "\(CoreDataStrings.attributeEmail) == %@", user.email),
            NSPredicate(format: "\(CoreDataStrings.attributeCity) == %@", user.city),
            NSPredicate(format: "\(CoreDataStrings.attributeStreet) == %@", user.street)
        ])
        
        do {
            let results = try self.managedContext.fetch(fetchRequest)
            
            guard let object = results.first else { return }
            self.managedContext.delete(object)
            try self.managedContext.save()
        }
        
        catch let error as NSError {
            print(error.localizedDescription)
            throw error
        }
    }
}
