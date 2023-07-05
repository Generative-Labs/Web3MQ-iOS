//
//  MessageStatusRequest.swift
//
//
//  Created by X Tommy on 2022/10/31.
//

import UIKit
import Web3MQNetworking

struct MessageStatusRequest: Web3MQRequest {

    typealias Response = EmptyDataResponse

    var method: HTTPMethod = .post

    var path: String = "/api/messages/status/"

    var signContent: String? {
        status.rawValue
    }

    var parameters: Parameters? {
        return ["messages": self.messagesIds, "status": status.rawValue, "topic": topic]
    }

    let messagesIds: [String]
    let status: MessageReadStatus
    let topic: String

}
