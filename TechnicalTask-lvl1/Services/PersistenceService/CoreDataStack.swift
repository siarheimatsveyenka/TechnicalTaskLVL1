//
//  CoreDataStack.swift
//  TechnicalTask-lvl1
//
//  Created by Сергей Матвеенко on 25.11.24.
//

import Foundation
import CoreData

class CoreDataStack {
  
  // MARK: - Parameters
  
  private let modelName: String
  
  private lazy var storeContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: self.modelName)
      
    container.loadPersistentStores { _, error in
      if let error = error as? NSError {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    }
      
    return container
  }()
  
  lazy var managedContext: NSManagedObjectContext = {
    self.storeContainer.viewContext
  }()
  
  // MARK: - Initialization
  
  init(modelName: String) {
    self.modelName = modelName
  }
}

// MARK: - Save context

extension CoreDataStack {
  func saveContext() {
    guard self.managedContext.hasChanges else { return }
    
    do {
      try self.managedContext.save()
    }
    
    catch let error as NSError {
      fatalError("Can't save managed context, error: \(error), \(error.userInfo)")
    }
  }
}
