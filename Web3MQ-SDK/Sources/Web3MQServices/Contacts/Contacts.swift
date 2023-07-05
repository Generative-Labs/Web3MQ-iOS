//
//  ContactUser.swift
//
//
//  Created by X Tommy on 2022/11/1.
//

import Foundation

public struct ContactUser: Codable, Hashable, Equatable {

    public let userId: String
    public let nickName: String?
    public let avatarUrl: String?

    enum CodingKeys: String, CodingKey {
        case userId = "userid"
        case nickName = "nickname"
        case avatarUrl = "avatar_url"
    }
}

public enum FollowStatus: String, Codable, Hashable {
    case following
    case follow_each
    case follower
    case empty = ""
}

///
public struct UserPermissionItem: Codable, Hashable {
    ///
    public let type: String

    ///
    public let value: String
}

public struct UserPermissions: Codable, Hashable {

    let friendRequest: UserPermissionItem?
    let lensPublic: UserPermissionItem?
    let emailPublic: UserPermissionItem?
    let emailReceive: UserPermissionItem?
    let phoneReceive: UserPermissionItem?

    enum CodingKeys: String, CodingKey {
        case friendRequest = "user:friend_request"
        case lensPublic = "lens.xyz:public"
        case emailPublic = "email:public"
        case emailReceive = "email:receive"
        case phoneReceive = "phone:receive"
    }
}

///
public struct FollowUser: Codable, Hashable {

    public let userId: String
    public var avatarUrl: String?
    public var nickName: String?

    public var followStatus: FollowStatus?
    public var permissions: UserPermissions?

    public var walletAddress: String?
    public var walletType: String?

    enum CodingKeys: String, CodingKey {
        case userId = "userid"
        case followStatus = "follow_status"
        case permissions = "permissions"
        case walletAddress = "wallet_address"
        case walletType = "wallet_type"
        case avatarUrl = "avatar_url"
        case nickName = "nickname"
    }

    public var displayName: String {
        if let nickName, !nickName.isEmpty {
            return nickName
        } else {
            return userId
        }
    }

}
