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

public enum PermissionValue: Codable, Hashable {
    case string(String)
    case int(Int)
    case double(Double)
    case bool(Bool)
    case array([PermissionValue])
    case dictionary([String: PermissionValue])

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let string = try? container.decode(String.self) {
            self = .string(string)
        } else if let int = try? container.decode(Int.self) {
            self = .int(int)
        } else if let double = try? container.decode(Double.self) {
            self = .double(double)
        } else if let bool = try? container.decode(Bool.self) {
            self = .bool(bool)
        } else if let array = try? container.decode([PermissionValue].self) {
            self = .array(array)
        } else if let dictionary = try? container.decode([String: PermissionValue].self) {
            self = .dictionary(dictionary)
        } else {
            throw DecodingError.dataCorruptedError(
                in: container, debugDescription: "Invalid value")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let string):
            try container.encode(string)
        case .int(let int):
            try container.encode(int)
        case .double(let double):
            try container.encode(double)
        case .bool(let bool):
            try container.encode(bool)
        case .array(let array):
            try container.encode(array)
        case .dictionary(let dictionary):
            try container.encode(dictionary)
        }
    }
}

///
public struct UserPermissionItem: Codable, Hashable {

    ///
    public let type: String

    /// public, follower, following, friend
    public let value: PermissionValue

    ///
    public func copyWith(type: String? = nil, value: PermissionValue? = nil) -> UserPermissionItem {
        return UserPermissionItem(type: type ?? self.type, value: value ?? self.value)
    }

}

public struct UserPermissions: Codable, Hashable {

    public let friendRequest: UserPermissionItem?
    public let lensPublic: UserPermissionItem?
    public let emailPublic: UserPermissionItem?
    public let emailReceive: UserPermissionItem?
    public let phoneReceive: UserPermissionItem?
    public let chat: UserPermissionItem?

    enum CodingKeys: String, CodingKey {
        case friendRequest = "user:friend_request"
        case lensPublic = "lens.xyz:public"
        case emailPublic = "email:public"
        case emailReceive = "email:receive"
        case phoneReceive = "phone:receive"
        case chat = "user:chat"
    }

    public func copyWith(
        friend: PermissionValue? = nil,
        chat: PermissionValue? = nil,
        lens: PermissionValue? = nil,
        emailPublic: PermissionValue? = nil,
        emailReceive: PermissionValue? = nil,
        phoneReceive: PermissionValue? = nil
    )
        -> UserPermissions
    {
        return UserPermissions(
            friendRequest: friend != nil
                ? self.friendRequest?.copyWith(value: friend) : self.friendRequest,
            lensPublic: lens != nil
                ? self.lensPublic?.copyWith(value: lens) : self.lensPublic,
            emailPublic: emailPublic != nil
                ? self.emailPublic?.copyWith(value: emailPublic) : self.emailPublic,
            emailReceive: emailReceive != nil
                ? self.emailReceive?.copyWith(value: emailReceive) : self.emailReceive,
            phoneReceive: phoneReceive != nil
                ? self.phoneReceive?.copyWith(value: phoneReceive) : self.phoneReceive,
            chat: chat != nil
                ? self.chat?.copyWith(value: chat) : self.chat
        )
    }

    public func copyWith(
        friend: UserPermissionItem? = nil,
        chat: UserPermissionItem? = nil,
        lens: UserPermissionItem? = nil,
        emailPublic: UserPermissionItem? = nil,
        emailReceive: UserPermissionItem? = nil,
        phoneReceive: UserPermissionItem? = nil
    )
        -> UserPermissions
    {
        return UserPermissions(
            friendRequest: friend ?? self.friendRequest,
            lensPublic: lens ?? self.lensPublic,
            emailPublic: emailPublic ?? self.emailPublic,
            emailReceive: emailReceive ?? self.emailReceive,
            phoneReceive: phoneReceive ?? self.phoneReceive,
            chat: chat ?? self.chat)
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
