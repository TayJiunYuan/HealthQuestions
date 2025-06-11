//
//  CoreDataProvider.swift
//  HealthQuestions
//
//  Created by Tay Jiun Yuan on 4/6/25.
//

import Foundation
import CoreData

class CoreDataProvider {
    static let shared = CoreDataProvider() // [LEARNING] instantiates singleton
    
    let persistentContainer: NSPersistentContainer
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext // [LEARNING] context is used to fetch, insert, delete, and save data.
    }
    
    private init() { // [LEARNING] Private init so that no one else can instantiate this class except for itself (done in the first line)
        persistentContainer = NSPersistentContainer(name: "AppModel")
        persistentContainer.loadPersistentStores { _, error in
            if let error {
                fatalError("Core Data store failed to initialize \(error)")
            }
        }
        
    }
}
