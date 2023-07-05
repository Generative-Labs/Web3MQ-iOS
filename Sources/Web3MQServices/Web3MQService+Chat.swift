//
//  Web3MQService+Chat.swift
//
//
//  Created by X Tommy on 2023/3/2.
//

import Foundation
import Web3MQNetworking

extension Web3MQService {

    public func updateMessageStatus(
        messageIds: [String],
        topicId: String,
        status: MessageReadStatus,
        timestamp: UInt64
    ) async throws {
        _ = try await client.send(
            request: MessageStatusRequest(
                messagesIds: messageIds,
                status: status,
                topic: topicId))
    }

    public func messageHistory(topicId: String, pageCount: Int, pageSize: Int) async throws
        -> Page<Message>
    {
        guard
            let messages = try await client.send(
                request: MessageHistoryRequest(
                    topicId: topicId, pageCount: pageCount, pageSize: pageSize)
            ).page
        else {
            throw Web3MQNetworkingError.responseFailed(reason: .jsonEncodingFailed)
        }
        return messages
    }

    public func channels(pageCount: Int, pageSize: Int) async throws -> [Channel] {
        return try await client.send(
            request: SessionListRequest(pageCount: pageCount, pageSize: pageSize)
        ).page?.result ?? []
    }

}
