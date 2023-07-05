//
//  MessageFetchRequest.swift
//
//
//  Created by X Tommy on 2022/11/24.
//

import Foundation
import Web3MQNetworking

struct MessageFetchRequest: Web3MQRequest {

    typealias Response = Message

    var method: HTTPMethod = .get

    var path: String = "/api/get_new_messages/"

    let syncTimestamp: TimeInterval

    var parameters: Parameters? {
        ["sync_timestamp": syncTimestamp]
    }

}
