//
//  ContactsRequest.swift
//
//
//  Created by X Tommy on 2023/2/2.
//

import Foundation
import Web3MQNetworking

struct ContactsRequest: Web3MQRequest {

    typealias Response = FollowUser

    var method: HTTPMethod = .get

    var path: String = "/api/user_follow_contacts/"

    let pageCount: Int

    let pageSize: Int

    var parameters: Parameters? {
        ["page": pageCount, "size": pageSize]
    }

    var signatureKey: String { "web3mq_user_signature" }

    init(pageCount: Int, pageSize: Int) {
        self.pageCount = pageCount
        self.pageSize = pageSize
    }

}
