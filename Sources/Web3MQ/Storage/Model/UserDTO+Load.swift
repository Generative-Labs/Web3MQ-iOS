//
//  UserDTO+Load.swift
//
//
//  Created by X Tommy on 2022/11/23.
//

import CoreData
import Foundation

extension UserDTO {

    static func load(id: String, context: NSManagedObjectContext) -> UserDTO? {
        load(by: id, context: context).first
    }

    static func loadOrCreate(id: String, context: NSManagedObjectContext) -> UserDTO {
        if let existing = load(id: id, context: context) {
            return existing
        }
        let user = UserDTO(context: context)
        user.id = id
        return user
    }

}
