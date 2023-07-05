//
//  MessagePayload.swift
//
//
//  Created by X Tommy on 2022/11/23.
//

import CoreData
import Foundation

public class UserPayload: Codable {

    public var id: String
    public var name: String?
    public var avatarURL: URL?

    public var displayName: String {
        name ?? id
    }

    public init(id: String, name: String? = nil, avatarURL: URL? = nil) {
        self.id = id
        self.name = name
        self.avatarURL = avatarURL
    }
}

public class CurrentUserPayload: UserPayload {

    public var lastSyncEventDate: Date?
    public var unreadMessageCount: Int64 = 0

    public var privateKey: String?

    public init(
        id: String, name: String? = nil, avatarURL: URL? = nil, lastSyncEventDate: Date? = nil,
        unreadMessageCount: Int64 = 0, privateKey: String? = nil
    ) {
        super.init(id: id, name: name, avatarURL: avatarURL)

        self.lastSyncEventDate = lastSyncEventDate
        self.unreadMessageCount = unreadMessageCount
        self.privateKey = privateKey
    }

    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }

    fileprivate static func create(fromDTO dto: CurrentUserDTO) throws -> CurrentUserPayload {
        guard let userId = dto.user?.id else { throw InvalidModel(dto) }
        let payload = CurrentUserPayload(
            id: userId,
            name: dto.user?.name,
            avatarURL: dto.user?.avatarURL,
            lastSyncEventDate: dto.lastSyncEventDate,
            unreadMessageCount: dto.unreadMessageCount,
            privateKey: dto.privateKey)
        payload.name = dto.user?.name
        payload.avatarURL = dto.user?.avatarURL
        payload.id = userId
        return payload
    }

}

struct MessageStatusPayload: Codable {
    let status: String
    let timestamp: Date
}

struct MessagePayload: Codable {

    let id: String
    let topicId: String
    let createdAt: Date
    let updatedAt: Date
    let locallyCreatedAt: Date
    let text: String

    let channel: ChannelPayload?
    let status: MessageStatusPayload?
    let user: UserPayload

}

struct ChannelPayload: Codable {

    let name: String

    let topicId: String

    let avatarURL: URL

}

extension CurrentUserDTO {

    func asModel() throws -> CurrentUserPayload {
        try CurrentUserPayload.create(fromDTO: self)
    }

}
