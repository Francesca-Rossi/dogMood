//
//  PersistenController.swift
//  MyDogState
//
//  Created by Francesca Rossi on 10/07/23.
//

import Foundation
import CoreData


//classe singleton
struct PersistenceController {
    static let shared = PersistenceController()
    let container: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "DogModel")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
