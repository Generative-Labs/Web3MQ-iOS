//
//  UserPermissionsRequest.swift
//
//
//  Created by X Tommy on 2023/2/9.
//

import Foundation
import Web3MQNetworking

public struct PermissionResponse: Codable {

    public let userId: String
    public let followStatus: String
    public let permissions: UserPermissions?

    enum CodingKeys: String, CodingKey {
        case userId = "target_userid"
        case followStatus = "follow_status"
        case permissions = "permissions"
    }

    /// following, follow_each
    public var isFollowing: Bool {
        return followStatus == "following" || followStatus == "follow_each"
    }

    /// follow_each, follower
    public var isFollowed: Bool {
        return followStatus == "follow_each" || followStatus == "follower"
    }

}

struct UserPermissionsRequest: Web3MQRequest {

    typealias Response = PermissionResponse

    var method: HTTPMethod = .post

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

struct PermissionSettingsRequest: Web3MQRequest {

    typealias Response = PermissionResponse

    var method: HTTPMethod = .get

    var path: String = "/api/get_user_permissions/"

    var signatureKey: String = "web3mq_user_signature"

}

struct UpdatePermissionSettingsRequest: Web3MQRequest {

    typealias Response = EmptyDataResponse

    var method: HTTPMethod = .post

    var path: String = "/api/update_user_permissions/"

    var signatureKey: String = "web3mq_user_signature"
    
    var permissions: UserPermissions

    var parameters: Parameters? {
        // convert permissions to dic
        do {
            let jsonData = try JSONEncoder().encode(permissions)
            if let jsonDict = try JSONSerialization.jsonObject(with: jsonData, options: [])
                as? [String: Any]
            {
                return ["permissions": jsonDict]
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }

    init(permissions: UserPermissions) {
        self.permissions = permissions
    }

}
