//
//  FollowersListRequest.swift
//
//
//  Created by X Tommy on 2023/1/20.
//

import Foundation
import Web3MQNetworking

struct FollowersListRequest: Web3MQRequest {

    typealias Response = FollowUser

    var method: HTTPMethod = .get

    var path: String = "/api/user_followers/"

    var pageCount: Int

    var pageSize: Int

    var parameters: Parameters? {
        ["page": pageCount, "size": pageSize]
    }

    var signatureKey: String { "web3mq_user_signature" }

}
