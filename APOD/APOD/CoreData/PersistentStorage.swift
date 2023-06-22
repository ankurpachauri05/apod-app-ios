//
//  PersistentStorage.swift
//  APOD
//
//  Created by Pachauri, Ankur on 20/06/23.
//

import Foundation
import CoreData

final class PersistentStorage {
    static let shared = PersistentStorage()

    private init() { }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "APOD")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    lazy var context = persistentContainer.viewContext
    
    // MARK: - Core Data saving support

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

    // MARK: - Core Data fetching support
    
    func fetchManagedObject<T: NSManagedObject>(managedObject: T.Type) -> [T]? {
        do {
            guard let result = try context.fetch(managedObject.fetchRequest()) as? [T] else { return nil }
            
            return result

        } catch let error {
            debugPrint(error)
        }
        
        return nil
    }
}

