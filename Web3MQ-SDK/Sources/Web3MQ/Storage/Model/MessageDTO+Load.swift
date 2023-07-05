//
//  File.swift
//
//
//  Created by X Tommy on 2022/11/23.
//

import CoreData
import Foundation
import Web3MQNetworking
import Web3MQServices

extension MessageDTO {

    static func load(id: String, context: NSManagedObjectContext) -> MessageDTO? {
        load(by: id, context: context).first
    }

    @discardableResult
    static func loadOrCreate(
        messageId: String,
        context: NSManagedObjectContext
    ) -> MessageDTO {
        if let existing = load(id: messageId, context: context) {
            return existing
        }

        let obj = MessageDTO(context: context)
        obj.id = messageId
        return obj
    }

    static func loadLastMessage(in topicId: String, context: NSManagedObjectContext) -> MessageDTO?
    {
        let request = fetchRequest()
        request.predicate = channelPredicate(with: topicId)
        //        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
        //            channelPredicate(with: topicId),
        //            .init(format: "type != %@", Web3MQMessageType.dAppBridge.rawValue),
        //            .init(format: "type != %@", Web3MQMessageType.walletBridge.rawValue)
        //        ])
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \MessageDTO.updatedAt, ascending: false)
        ]
        request.fetchLimit = 1
        return load(by: request, context: context).first
    }

    static func channelPredicate(with topicId: String) -> NSPredicate {
        .init(format: "topicId == %@", topicId)
    }

    func asModel() throws -> Message {
        Message(
            cipherSuite: cipherSuite ?? "NONE",
            from: user?.id ?? "",
            topic: topicId ?? "",
            messageId: id ?? "",
            timestamp: Int((updatedAt?.timeIntervalSince1970 ?? 0) * 1000),
            payload: text?.data(using: .utf8)?.base64EncodedString() ?? "",
            messageStatus: Message.Status(
                status: MessageStatus(rawValue: messageStatus?.status ?? ""),
                timestamp: Int(messageStatus?.timestamp?.timeIntervalSince1970 ?? 0) * 1000))
    }

}
