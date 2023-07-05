//
//  Notification.swift
//  
//
//  Created by X Tommy on 2023/1/16.
//

import Foundation
import Web3MQNetworking

public struct Notification: Codable, Hashable {
    
    public let id: String
    public let title: String?
    public let content: String?
    public let type: String?
    public let timestamp: UInt64
    public let topicId: String
    public let status: String
    public let from: String
    
    public var following: Bool = false
    
    public init(notificationMessage: NotificationMessage) {
        self.id = notificationMessage.messageID
        self.title = notificationMessage.payloadContent?.title
        self.content = notificationMessage.payloadContent?.content
        self.type = notificationMessage.payloadContent?.type
        self.timestamp = notificationMessage.timestamp
        self.topicId = notificationMessage.contentTopic
        self.status = notificationMessage.read ? "read": "received"
        self.from = notificationMessage.comeFrom
    }
    
    public init(searchNotification: SearchedNotificationMessage) {
        self.id = searchNotification.messageId
        self.title = searchNotification.payload.title
        self.content = searchNotification.payload.content
        self.type = searchNotification.payload.type
        self.timestamp = UInt64(searchNotification.payload.timestamp)
        self.topicId = searchNotification.topic
        self.status = searchNotification.status
        self.from = searchNotification.from
    }
    
}
