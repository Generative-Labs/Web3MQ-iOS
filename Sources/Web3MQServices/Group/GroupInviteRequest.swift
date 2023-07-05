//
//  GroupInviteRequest.swift
//
//
//  Created by X Tommy on 2022/11/2.
//

import Foundation
import Web3MQNetworking

struct GroupInviteRequest: Web3MQRequest {

    typealias Response = Group

    var method: HTTPMethod = .post

    var path: String = "/api/group_invitation/"

    let groupId: String
    let members: [String]

    var signContent: String? {
        groupId
    }

    var parameters: Parameters? {
        ["groupid": groupId, "members": members]
    }

    init(groupId: String, members: [String]) {
        self.groupId = groupId
        self.members = members
    }

}
