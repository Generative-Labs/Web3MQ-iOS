//
//  GroupListRequest.swift
//
//
//  Created by X Tommy on 2022/11/2.
//

import UIKit
import Web3MQNetworking

struct GroupListRequest: Web3MQRequest {

    typealias Response = Group

    var method: HTTPMethod = .get

    var path: String = "/api/groups/"

    let pageCount: Int
    let pageSize: Int

    var signatureKey: String = "web3mq_signature"

    var parameters: Parameters? {
        ["page": pageCount, "size": pageSize]
    }

    init(pageCount: Int, pageSize: Int) {
        self.pageCount = pageCount
        self.pageSize = pageSize
    }

}
