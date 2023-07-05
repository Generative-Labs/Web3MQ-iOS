//
//  File.swift
//
//
//  Created by X Tommy on 2022/11/25.
//

import CoreData
import Foundation

enum UserRepository {

    static func saveUser(payload: UserPayload, context: NSManagedObjectContext) -> UserDTO {
        let dto = UserDTO.loadOrCreate(id: payload.id, context: context)
        dto.name = payload.name
        dto.avatarURL = payload.avatarURL
        return dto
    }

}
