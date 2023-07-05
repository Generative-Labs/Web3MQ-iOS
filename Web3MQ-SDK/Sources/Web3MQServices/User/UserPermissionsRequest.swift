//
//  UserPermissionsRequest.swift
//
//
//  Created by X Tommy on 2023/2/9.
//

import Foundation
import Web3MQNetworking

struct PermissionResponse: Codable {

    public let permissions: UserPermissions?
}

struct UserPermissionsRequest: Web3MQRequest {

    typealias Response = PermissionResponse

    var method: HTTPMethod = .get

    var path: String = "/api/get_target_user_permissions/"

    let targetUserId: String

    var signatureKey: String = "web3mq_user_signature"

    // TODO: 将 `userid` 字段改为 `target_user_id`
    var parameters: Parameters? {
        return ["target_userid": targetUserId]
    }

    init(targetUserId: String) {
        self.targetUserId = targetUserId
    }

}
