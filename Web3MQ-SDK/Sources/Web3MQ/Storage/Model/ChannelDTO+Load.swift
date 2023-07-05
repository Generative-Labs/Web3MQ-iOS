//
//  File.swift
//
//
//  Created by X Tommy on 2022/11/23.
//

import CoreData
import Foundation
import Web3MQServices

extension ChannelDTO {

    static func fetchRequest(for topicId: String) -> NSFetchRequest<ChannelDTO> {
        let request = NSFetchRequest<ChannelDTO>(entityName: ChannelDTO.entityName)
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \ChannelDTO.updatedAt, ascending: false)
        ]
        request.predicate = NSPredicate(format: "topicId == %@", topicId)
        return request
    }

    static func load(topicId: String, context: NSManagedObjectContext) -> ChannelDTO? {
        let request = fetchRequest(for: topicId)
        return load(by: request, context: context).first
    }

    static func loadOrCreate(topicId: String, context: NSManagedObjectContext) -> ChannelDTO {
        let request = fetchRequest(for: topicId)
        if let existing = load(by: request, context: context).first {
            return existing
        }
        let channel = ChannelDTO(context: context)
        channel.topicId = topicId
        return channel
    }

    func asModel() throws -> ChannelItem { try .create(fromDTO: self) }

}

public struct ChannelItem: Hashable {

    public let channelId: String

    public let topicId: String

    public let name: String?

    public let avatarURL: URL?

    public var badge: String?

    public var isHidden = false

    public var lastMessageAt: Date?

    public var lastMessageText: String?

    public var memberCount: Int64?

    public var updatedAt: Date?

    public var type: ChannelType

    public init(channel: Channel) {
        self.channelId = channel.channelId
        self.topicId = channel.topicId
        self.name = channel.sessionName
        self.avatarURL = URL(string: channel.avatarUrl ?? "")
        self.type = channel.channelType
    }

    public init(
        channelId: String, topicId: String, name: String?, avatarURL: URL?, badge: String?,
        isHidden: Bool, lastMessageAt: Date?, lastMessageText: String?, memberCount: Int64?,
        updatedAt: Date?, type: ChannelType
    ) {
        self.topicId = topicId
        self.name = name
        self.avatarURL = avatarURL
        self.badge = badge
        self.isHidden = isHidden
        self.lastMessageAt = lastMessageAt
        self.lastMessageText = lastMessageText
        self.memberCount = memberCount
        self.updatedAt = updatedAt
        self.type = type
        self.channelId = channelId
    }

    fileprivate static func create(fromDTO dto: ChannelDTO) throws -> ChannelItem {
        guard dto.isValid,
            let context = dto.managedObjectContext,
            let topicId = dto.topicId,
            let currentUserId = ChatClient.`default`.user?.userId
        else {
            throw InvalidModel(dto)
        }

        let unreadCount: () -> Int64 = {
            guard dto.isValid else { return 0 }

            // Fetch count of all mentioned messages after last read
            // (this is not 100% accurate but it's the best we have)
            let unreadMentionsRequest = NSFetchRequest<MessageDTO>(
                entityName: MessageDTO.entityName)
            unreadMentionsRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
                MessageDTO.channelPredicate(with: topicId),
                .init(format: "Not(messageStatus.status == %@)", "read"),
                .init(format: "user.id != %@", currentUserId),
            ])

            do {
                return Int64(try context.fetch(unreadMentionsRequest).count)
            } catch {
                print(
                    "Failed to fetch unread counts for channel `\(dto.topicId ?? "")`. Error: \(error)"
                )
                return 0
            }
        }

        let fetchLatestMessage: () -> Message? = {
            guard dto.isValid else { return nil }
            return try? MessageDTO
                .loadLastMessage(
                    in: dto.topicId ?? "",
                    context: context
                )?
                .asModel()
        }

        let lastestMessage = fetchLatestMessage()
        return ChannelItem(
            channelId: dto.topicId ?? "",
            topicId: topicId,
            name: dto.name,
            avatarURL: dto.avatarURL,
            badge: "\(unreadCount())",
            isHidden: dto.isHidden,
            lastMessageAt: lastestMessage?.updatedAt,
            lastMessageText: lastestMessage?.payloadText,
            memberCount: dto.memberCount,
            updatedAt: lastestMessage?.updatedAt,
            type: ChannelType(rawValue: dto.type ?? "") ?? .user)
    }

}
