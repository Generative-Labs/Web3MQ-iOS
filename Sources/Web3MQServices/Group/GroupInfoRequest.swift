//
//  GroupInfoRequest.swift
//
//
//  Created by X Tommy on 2023/2/9.
//

import Foundation
import Web3MQNetworking

struct GroupInfoRequest: Web3MQRequest {

    typealias Response = Group

    var method: HTTPMethod = .get

    var path: String = "/api/group_info/"

    let groupId: String

    var signatureKey: String = "web3mq_user_signature"

    var parameters: Parameters? {
        ["groupid": groupId]
    }

    init(groupId: String) {
        self.groupId = groupId
    }

}
