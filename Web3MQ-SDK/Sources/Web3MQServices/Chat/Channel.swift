//
//  Session.swift
//
//
//  Created by X Tommy on 2022/11/2.
//

import Foundation

public enum ChannelType: String, Codable, CaseIterable {
    case user
    case group
    case topic

    public static var all: Set<ChannelType> {
        Set(ChannelType.allCases)
    }
}

public struct Channel: Codable, Hashable {

    public let topicId: String

    public let topicType: String

    public let channelId: String

    public let channelType: ChannelType

    public let sessionName: String?

    public let avatarUrl: String?

    public let avatarBase64: String?

    enum CodingKeys: String, CodingKey {
        case topicId = "topic"
        case topicType = "topic_type"
        case channelId = "chatid"
        case channelType = "chat_type"
        case sessionName = "chat_name"
        case avatarUrl = "avatar_url"
        case avatarBase64 = "avatar_base64"
    }

    public init(
        topicId: String, topicType: String, sessionId: String, sessionType: ChannelType,
        sessionName: String?, avatarUrl: String?, avatarBase64: String?
    ) {
        self.topicId = topicId
        self.topicType = topicType
        self.channelId = sessionId
        self.channelType = sessionType
        self.sessionName = sessionName
        self.avatarUrl = avatarUrl
        self.avatarBase64 = avatarBase64
    }

}
