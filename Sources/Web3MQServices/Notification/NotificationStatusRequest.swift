//
//  NotificationStatusRequest.swift
//
//
//  Created by X Tommy on 2022/10/12.
//

import Foundation
import Web3MQNetworking

struct NotificationStatusRequest: Web3MQRequest {

    typealias Response = EmptyDataResponse

    var method: HTTPMethod = .post

    var path: String = "/api/notification/status/"

    var signContent: String? {
        status.rawValue
    }

    var parameters: Parameters? {
        return ["messages": self.notificationIds, "status": status.rawValue]
    }

    let notificationIds: [String]
    let status: NotificationStatus

    init(notificationIds: [String], status: NotificationStatus) {
        self.notificationIds = notificationIds
        self.status = status
    }

}
