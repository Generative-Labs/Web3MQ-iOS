//
//  File.swift
//
//
//  Created by X Tommy on 2022/10/12.
//

import Foundation
import Web3MQNetworking

public enum NotificationType: String, Codable {

    case receivedFriendRequest = "system.friend_request"
    case sendFriendRequest = "system.agree_friend_request"
    case groupInvitation = "group_invitation"
    case subscription = "subscription"
    case provider = "provider.notification"

    public static let all: [NotificationType] = [
        NotificationType.receivedFriendRequest, NotificationType.sendFriendRequest,
        NotificationType.groupInvitation, NotificationType.subscription, NotificationType.provider,
    ]
}

struct GetNotificationsRequest: Web3MQRequest {

    typealias Response = SearchedNotificationMessage

    var method: HTTPMethod = .get

    var path: String = "/api/notification/history/"

    var signContent: String? {
        type.rawValue
    }

    //    "userid": userId,
    //    "timestamp": timestamp,
    //    "web3mq_signature": signature
    var parameters: Parameters? {
        return [
            "notice_type": type.rawValue,
            "size": size,
            "page": page,
            "version": 2,
        ]
    }

    let type: NotificationType
    let page: Int
    let size: Int

    init(
        type: NotificationType,
        page: Int,
        size: Int
    ) {
        self.type = type
        self.page = page
        self.size = size
    }

}

struct QueryNotificationsRequest: Web3MQRequest {

    typealias Response = SearchedNotificationMessage

    var method: HTTPMethod = .get

    var path: String = "/api/notification/history/"

    //    var signContent: String? {
    //        types.reduce("") { $0 + $1.rawValue }
    //    }

    //    "userid": userId,
    //    "timestamp": timestamp,
    //    "web3mq_signature": signature
    var parameters: Parameters? {
        return [
            //            "notice_types": types.map({ $0.rawValue }),
            "size": size,
            "page": page,
            "version": 2,
        ]
    }

    let types: [NotificationType]
    let page: Int
    let size: Int

    init(
        types: [NotificationType],
        page: Int,
        size: Int
    ) {
        self.types = types
        self.page = page
        self.size = size
    }

}
