//
//  Interceptor.swift
//
//
//  Created by X Tommy on 2022/11/16.
//

import Foundation
import Web3MQNetworking
import Web3MQServices

public protocol Interceptor {

    /// Handles a message by returning a new message or throwing an error.
    ///
    /// - Parameter message: The message to handle.
    /// - Returns: The new message.
    /// - Throws: An error if an error occurred while handling the message.
    func handle(message: Web3MQMessage) async throws -> Web3MQMessage

    func handleMessageStatusUpdate(status: Web3MQMessageStatusItem) async throws

}

public struct AnyInterceptor: Interceptor {

    typealias MessageInterceptor = (Web3MQMessage) async throws -> Web3MQMessage
    typealias MessageStatusInterceptor = (Web3MQMessageStatusItem) async throws -> Void

    let handler: MessageInterceptor

    let statusHandler: MessageStatusInterceptor?

    init(
        handler: @escaping MessageInterceptor,
        statusHandler: MessageStatusInterceptor?
    ) {
        self.handler = handler
        self.statusHandler = statusHandler
    }

    public func handle(message: Web3MQMessage) async throws -> Web3MQMessage {
        try await handler(message)
    }

    public func handleMessageStatusUpdate(status: Web3MQMessageStatusItem) async throws {
        try await statusHandler?(status)
    }

}

/// The interceptor for storage.
struct StorageInterceptor: Interceptor {

    func handle(message: Web3MQMessage) async throws -> Web3MQMessage {
        cacheMessage(message)
        return message
    }

    func handleMessageStatusUpdate(status: Web3MQMessageStatusItem) async throws {
        MessageRepository.updateMessagesStatus(
            messageIds: [status.messageID], status: status.messageStatus.rawValue,
            timestamp: status.timestamp, context: persistentContainer.writableContext)
    }

    private func cacheMessage(_ message: Web3MQMessage) {
        MessageRepository.insertMessage(
            message: Message(web3mqMessage: message),
            context: persistentContainer.writableContext)
    }

}
