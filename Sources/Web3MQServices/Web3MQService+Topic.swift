//
//  Web3MQService+Topic.swift
//
//
//  Created by X Tommy on 2023/3/2.
//

import Foundation
import Web3MQNetworking

extension Web3MQService {

    /// create a topic
    public func createTopic(_ topicName: String?) async throws -> String {
        try await client.send(request: CreateTopicRequest(topicName: topicName))
            .data?.topicId ?? ""
    }

    public func subscribeTopic(_ topicId: String) async throws {
        try await client.send(
            request: SubscribeTopicRequest(topicId: topicId))
    }

    public func publish(toTopic topicId: String, title: String, content: String) async throws {
        try await client.send(
            request: SendTopicMessageRequest(topicId: topicId, title: title, content: content))
    }

    public func myCreateTopics(pageCount: Int, pageSize: Int) async throws -> Page<Topic> {
        try await client.send(
            request: MyCreateTopicListRequest(pageCount: pageCount, pageSize: pageSize)
        ).page ?? Page<Topic>()
    }

    public func mySubscribeTopics(pageCount: Int, pageSize: Int) async throws -> Page<Topic> {
        try await client.send(
            request: MySubscribeTopicListRequest(pageCount: pageCount, pageSize: pageSize)
        ).page ?? Page<Topic>()
    }

}
