//
//  Group.swift
//
//
//  Created by X Tommy on 2022/11/2.
//

import Foundation

public struct Group: Codable, Hashable {

    public let groupId: String
    public let avatarUrl: String?
    public let groupName: String?

    enum CodingKeys: String, CodingKey {
        case groupId = "groupid"
        case avatarUrl = "avatar_url"
        case groupName = "group_name"
    }
}
