//
//  SessionListRequest.swift
//
//
//  Created by X Tommy on 2022/11/2.
//

import Foundation
import Web3MQNetworking

struct SessionListRequest: Web3MQRequest {

    typealias Response = Channel

    var method: HTTPMethod = .get

    var path: String = "/api/chats/"

    let pageCount: Int
    let pageSize: Int

    var parameters: Parameters? {
        ["page": pageCount, "size": pageSize]
    }

}
