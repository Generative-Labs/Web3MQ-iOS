//
//  Storage.swift
//
//
//  Created by X Tommy on 2022/11/16.
//

import CoreData
import Foundation

private let idKey = "id"

extension NSManagedObject {

    @objc class var entityName: String {
        "\(self)"
    }

    static func load<T: NSManagedObject>(by id: String, context: NSManagedObjectContext) -> [T] {
        load(keyPath: idKey, equalTo: id, context: context)
    }

    static func load<T: NSManagedObject>(
        keyPath: String, equalTo value: String, context: NSManagedObjectContext
    ) -> [T] {
        let request = NSFetchRequest<T>(entityName: entityName)
        request.predicate = NSPredicate(format: "%K == %@", keyPath, value)
        return load(by: request, context: context)
    }

    static func load<T: NSManagedObject>(
        by request: NSFetchRequest<T>, context: NSManagedObjectContext
    ) -> [T] {
        request.entity = NSEntityDescription.entity(forEntityName: T.entityName, in: context)!
        do {
            return try context.fetch(request)
        } catch {
            return []
        }
    }

    var isValid: Bool {
        guard let context = managedObjectContext else { return false }
        do {
            _ = try context.existingObject(with: objectID)
        } catch {
            return false
        }
        return true
    }
}

protocol NSFetchRequestGettable {}

extension NSFetchRequestGettable where Self: NSManagedObject {

    static func fetchRequest(id: String) -> NSFetchRequest<Self> {
        fetchRequest(keyPath: idKey, equalTo: id)
    }

    static func fetchRequest(keyPath: String, equalTo value: String) -> NSFetchRequest<Self> {
        let request = NSFetchRequest<Self>(entityName: entityName)
        request.predicate = NSPredicate(format: "%K == %@", keyPath, value)
        return request
    }
}

extension NSManagedObject: NSFetchRequestGettable {}
