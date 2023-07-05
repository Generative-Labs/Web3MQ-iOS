//
//  File.swift
//
//
//  Created by X Tommy on 2022/11/24.
//

import CoreData
import Foundation

struct InvalidModel: LocalizedError {
    let id: NSManagedObjectID
    let entityName: String?

    init(_ model: NSManagedObject) {
        id = model.objectID
        entityName = model.entity.name
    }

    var errorDescription: String? {
        "\(entityName ?? "Unknown") object with ID \(id) is invalid"
    }
}
