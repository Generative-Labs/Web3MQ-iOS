//
//  GroupMemberListRequest.swift
//
//
//  Created by X Tommy on 2022/11/2.
//

import UIKit
import Web3MQNetworking

struct GroupMemberListRequest: Web3MQRequest {

    typealias Response = ContactUser

    var method: HTTPMethod = .get

    var path: String = "/api/group_members/"

    let groupId: String
    let pageCount: Int
    let pageSize: Int

    var signContent: String? {
        groupId
    }

    var parameters: Parameters? {
        ["groupid": groupId, "page": pageCount, "size": pageSize]
    }

    init(groupId: String, pageCount: Int, pageSize: Int) {
        self.groupId = groupId
        self.pageCount = pageCount
        self.pageSize = pageSize
    }

}
