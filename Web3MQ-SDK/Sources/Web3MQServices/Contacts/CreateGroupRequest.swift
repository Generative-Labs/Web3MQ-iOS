//
//  CreateGroupRequest.swift
//
//
//  Created by X Tommy on 2022/11/2.
//

import Foundation
import Web3MQNetworking

struct CreateGroupRequest: Web3MQRequest {

    typealias Response = Group

    var method: HTTPMethod = .post

    var path: String = "/api/groups/"

    let groupName: String
    let avatarUrl: String?

    var parameters: Parameters? {
        var params = ["group_name": groupName]
        params["avatar_url"] = avatarUrl
        return params
    }

    init(groupName: String, avatarUrl: String?) {
        self.groupName = groupName
        self.avatarUrl = avatarUrl
    }

}
