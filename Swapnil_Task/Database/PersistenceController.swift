//
//  PersistenceController.swift
//  Swapnil_Task
//
//  Created by Sonkar, Swapnil on 16/01/25.
//

import CoreData
import Foundation

class PersistenceController {
    static let shared = PersistenceController()
    
    private init() {}
 
    lazy var persistentContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: "Swapnil_Task_DB")
            container.loadPersistentStores { _, error in
                if let error = error {
                    fatalError("Unresolved error \(error)")
                }
            }
            return container
        }()
    
    lazy var privateContext: NSManagedObjectContext = {
        return persistentContainer.newBackgroundContext()
    }()
    
    var context: NSManagedObjectContext {
            return persistentContainer.viewContext
        }

    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
