//
//  CreateTopicRequest.swift
//
//
//  Created by X Tommy on 2022/10/20.
//

import Foundation
import Web3MQNetworking

public struct Topic: Codable, Hashable {

    public let topicId: String
    public let name: String?
    public let creationTimestamp: Int

    enum CodingKeys: String, CodingKey {
        case topicId = "topicid"
        case name = "topic_name"
        case creationTimestamp = "create_at"
    }

    public func toSession() -> Channel {
        Channel(
            topicId: topicId,
            topicType: "topic",
            sessionId: topicId,
            sessionType: .topic,
            sessionName: name,
            avatarUrl: nil,
            avatarBase64: nil)
    }

}

struct CreateTopicRequest: Web3MQRequest {

    typealias Response = Topic

    var method: HTTPMethod = .post

    var path: String = "/api/create_topic/"

    var signContent: String? {
        nil
    }

    // "topic_name": topic_name
    var parameters: Parameters? {
        var temp = [String: Any]()
        temp["topic_name"] = topicName
        return temp
    }

    let topicName: String?

    init(topicName: String?) {
        self.topicName = topicName
    }

}
