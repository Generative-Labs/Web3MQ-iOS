//
//  MessageHistoryRequest.swift
//
//
//  Created by X Tommy on 2022/11/4.
//

import Foundation
import Web3MQNetworking

public struct Message: Codable, Hashable {

    public struct Status: Codable, Hashable {

        public let status: MessageStatus?
        public let timestamp: Int?

        public init(status: MessageStatus?, timestamp: Int?) {
            self.status = status
            self.timestamp = timestamp
        }
    }

    public var cipherSuite: String = "NONE"
    public let from: String
    public let topic: String
    public let messageId: String
    public let timestamp: Int

    /// base64
    public let payload: String

    public let messageStatus: Status?

    public var payloadText: String? {
        guard let data = Data(base64Encoded: payload) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }

    public var updatedAt: Date {
        Date(timeIntervalSince1970: TimeInterval(timestamp / 1000))
    }

    enum CodingKeys: String, CodingKey {
        case cipherSuite = "cipher_suite"
        case from = "from"
        case topic = "topic"
        case messageId = "messageid"
        case timestamp = "timestamp"
        case payload = "payload"
        case messageStatus = "message_status"
    }

    public init(
        cipherSuite: String, from: String, topic: String, messageId: String, timestamp: Int,
        payload: String, messageStatus: Status
    ) {
        self.cipherSuite = cipherSuite
        self.from = from
        self.topic = topic
        self.messageId = messageId
        self.timestamp = timestamp
        self.payload = payload
        self.messageStatus = messageStatus
    }

    public init(web3mqMessage: Web3MQMessage) {
        self.cipherSuite = web3mqMessage.cipherSuite
        self.from = web3mqMessage.comeFrom
        self.topic = web3mqMessage.contentTopic
        self.messageId = web3mqMessage.messageID
        self.timestamp = Int(web3mqMessage.timestamp)
        self.payload = web3mqMessage.payload.base64EncodedString()
        self.messageStatus = nil
    }

}

struct MessageHistoryRequest: Web3MQRequest {

    typealias Response = Message

    var method: HTTPMethod = .get

    var path: String = "/api/messages/history/"

    let topicId: String
    let pageCount: Int
    let pageSize: Int

    var parameters: Parameters? {
        ["topic": topicId, "page": pageCount, "size": pageSize]
    }

    var signContent: String? {
        topicId
    }

}
