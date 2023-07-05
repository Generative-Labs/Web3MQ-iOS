//
//  File.swift
//
//
//  Created by X Tommy on 2022/11/16.
//

import CoreData
import Foundation
import Web3MQNetworking
import Web3MQServices

enum MessageRepository {

    static func fetchRequest(for messageId: String) -> NSFetchRequest<MessageDTO> {
        let request = MessageDTO.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \MessageDTO.updatedAt, ascending: false)
        ]
        request.predicate = NSPredicate(format: "id == %@", messageId)
        return request
    }

    static func fetchMessage(messageId: String, context: NSManagedObjectContext) -> MessageDTO? {
        let request = fetchRequest(for: messageId)
        return try? context.fetch(request).first
    }

    static func fetchMessages(messageIds: [String], context: NSManagedObjectContext) -> [MessageDTO]
    {
        let request = MessageDTO.fetchRequest()
        request.predicate = NSPredicate(format: "id IN %@", messageIds)
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \MessageDTO.updatedAt, ascending: false)
        ]
        return (try? context.fetch(request)) ?? []
    }

    static func fetchMessagesNotStatus(
        messageIds: [String],
        status: String,
        context: NSManagedObjectContext
    ) -> [MessageDTO] {
        let request = MessageDTO.fetchRequest()
        request.predicate = NSPredicate(
            format: "id IN %@ and messageStatus.status != %@", messageIds, status)
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \MessageDTO.updatedAt, ascending: false)
        ]
        return (try? context.fetch(request)) ?? []
    }

    static func fetchAllMessages(
        topicId: String,
        context: NSManagedObjectContext
    ) -> [MessageDTO] {
        let request = MessageDTO.fetchRequest()
        request.predicate = NSPredicate(format: "topicId == %@", topicId)
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \MessageDTO.updatedAt, ascending: false)
        ]
        return (try? context.fetch(request)) ?? []
    }

    static func insertMessage(
        message: Message,
        context: NSManagedObjectContext
    ) {
        let dto = MessageDTO.loadOrCreate(messageId: message.messageId, context: context)

        let topicId: String
        if message.from == ChatClient.`default`.user?.userId {
            topicId = message.topic
        } else {
            topicId = message.from
        }
        let user = UserDTO.loadOrCreate(id: message.from, context: context)

        let channel = ChannelDTO.loadOrCreate(topicId: topicId, context: context)
        if channel.type == ChannelType.user.rawValue {
            channel.name = user.name
        }
        channel.updatedAt = message.updatedAt

        dto.text = message.payloadText
        dto.createdAt = message.updatedAt
        dto.updatedAt = message.updatedAt
        dto.user = user
        dto.channel = channel
        dto.locallyCreatedAt = message.updatedAt
        dto.topicId = topicId

        let statusDto = MessageStatusDTO(context: context)
        statusDto.status = message.messageStatus?.status?.rawValue ?? ""
        statusDto.timestamp = Date(
            timeIntervalSince1970: Double(message.messageStatus?.timestamp ?? 0) / 1000)
        dto.messageStatus = statusDto

        context.saveIfNeeded()
    }

    static func insertMessages(
        messages: [Message],
        context: NSManagedObjectContext
    ) {
        messages.forEach { insertMessage(message: $0, context: context) }
    }

    static func updateMessagesStatus(
        messageIds: [String],
        status: String,
        timestamp: UInt64,
        context: NSManagedObjectContext
    ) {
        let messages = fetchMessagesNotStatus(
            messageIds: messageIds, status: status, context: context)
        messages.forEach { message in
            let _status = MessageStatusDTO(context: context)
            _status.status = status
            _status.timestamp = Date(timeIntervalSince1970: Double(timestamp) / 1000.0)
            message.messageStatus = _status
        }
        context.saveIfNeeded()
    }

    static func deleteAllMessages(topicId: String, context: NSManagedObjectContext) {
        let messages = fetchAllMessages(topicId: topicId, context: context)
        messages.forEach { context.delete($0) }
        context.saveIfNeeded()
    }

    static func deleteMessages(_ messageIds: [String]) async {

    }

    static func deleteMessages(messageIds: [String]) async {

    }

    static func deleteMessages(conversationIds: [String]) async {

    }

    static func fetchLastVisibleMessage(topicId: String) -> MessageDTO? {
        let request = MessageDTO.fetchRequest()
        request.predicate = NSPredicate(format: "topicId == %@", topicId)
        request.sortDescriptors = [NSSortDescriptor(key: "updatedAt", ascending: false)]
        request.fetchLimit = 1
        return try? persistentContainer.writableContext.fetch(request).last
    }

    static func updateReadReceipt(topicId: String, timestamp: Int64) async {

    }

}
