//
//  CurrentUserRepository.swift
//
//
//  Created by X Tommy on 2022/11/25.
//

import CoreData
import Foundation

extension CurrentUserDTO {

    fileprivate static func load(context: NSManagedObjectContext) -> CurrentUserDTO? {
        let request = NSFetchRequest<CurrentUserDTO>(entityName: CurrentUserDTO.entityName)
        let result = load(by: request, context: context)
        return result.first
    }

    fileprivate static func loadOrCreate(context: NSManagedObjectContext) -> CurrentUserDTO {
        let request = NSFetchRequest<CurrentUserDTO>(entityName: CurrentUserDTO.entityName)
        let result = load(by: request, context: context)
        if let existing = result.first {
            return existing
        }
        return CurrentUserDTO(context: context)
    }

}

enum CurrentUserRepository {

    static func currentUser(context: NSManagedObjectContext) -> CurrentUserDTO? {
        CurrentUserDTO.load(context: context)
    }

    static func saveCurrentUser(
        payload: CurrentUserPayload,
        context: NSManagedObjectContext
    ) -> CurrentUserDTO {
        let dto = CurrentUserDTO.loadOrCreate(context: context)
        dto.user = UserRepository.saveUser(payload: payload, context: context)
        context.saveIfNeeded()
        return dto
    }

    @discardableResult
    static func saveCurrentUser(
        userId: String,
        privateKey: String?,
        didValue: String?,
        didType: String?,
        context: NSManagedObjectContext
    ) -> CurrentUserDTO {
        let dto = CurrentUserDTO.loadOrCreate(context: context)
        if dto.user?.id != userId {
            dto.user = UserDTO.loadOrCreate(id: userId, context: context)
            dto.lastSyncEventDate = nil
            dto.unreadMessageCount = 0
        }
        dto.privateKey = privateKey
        dto.didValue = didValue
        dto.didType = didType
        context.saveIfNeeded()
        return dto
    }

    static func deleteUser(context: NSManagedObjectContext) {
        guard let dto = CurrentUserDTO.load(context: context) else {
            return
        }
        context.delete(dto)
        context.saveIfNeeded()
    }

}
