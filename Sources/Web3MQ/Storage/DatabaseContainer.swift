//
//  DatabaseContainer.swift
//
//
//  Created by X Tommy on 2022/11/17.
//

import CoreData
import Foundation

/// Convenience subclass of `NSPersistentContainer` allowing easier setup of the database stack.
public class DatabaseContainer: NSPersistentContainer {

    public lazy var writableContext: NSManagedObjectContext = {
        let context = newBackgroundContext()
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }()

    public func saveContext() {
        let context = writableContext
        context.saveIfNeeded()
    }

}

extension NSManagedObjectContext {

    public func saveIfNeeded() {
        guard hasChanges else {
            return
        }
        try? save()
    }
}

public var persistentContainer: DatabaseContainer = {
    let modelURL = Bundle.module.url(forResource: "Model", withExtension: "momd")!
    let model = NSManagedObjectModel(contentsOf: modelURL)!
    let container = DatabaseContainer(name: "Web3MQ", managedObjectModel: model)
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
        if let error = error as NSError? {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    })
    return container
}()
