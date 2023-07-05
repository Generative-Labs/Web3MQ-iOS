//
//  GetMyProfileRequest.swift
//
//
//  Created by X Tommy on 2022/10/31.
//

import Foundation
import Web3MQNetworking

public struct UserProfile: Codable {

    public struct Stats: Codable {
        public let totalFollowers: Int
        public let totalFollowing: Int

        enum CodingKeys: String, CodingKey {
            case totalFollowers = "total_followers"
            case totalFollowing = "total_following"
        }
    }

    public let userId: String
    public let walletAddress: String?
    public let walletType: String?
    public let nickname: String?
    public let avatarUrl: String?
    public let stats: Stats?

    enum CodingKeys: String, CodingKey {
        case userId = "userid"
        case walletAddress = "wallet_address"
        case walletType = "wallet_type"
        case nickname = "nickname"
        case avatarUrl = "avatar_url"
        case stats = "stats"
    }

    public var displayName: String {
        if let nickname, !nickname.isEmpty {
            return nickname
        } else {
            return userId
        }
    }

}

struct GetMyProfileRequest: Web3MQRequest {

    typealias Response = UserProfile

    var method: HTTPMethod = .get

    var path: String = "/api/my_profile/"

    var signContent: String? { nil }

}

struct GetPublicProfileRequest: Web3MQRequest {

    typealias Response = UserProfile

    var method: HTTPMethod = .get

    var path: String = "/api/get_user_public_profile/"

    let userId: String

    let didType: String

    let didValue: String

    var parameters: Parameters? {
        [
            "my_userid": userId,
            "did_type": didType,
            "did_value": didValue,
            "timestamp": Date().millisecondsSince1970,
        ]
    }

    init(userId: String, didType: String, didValue: String) {
        self.userId = userId
        self.didType = didType
        self.didValue = didValue
    }

}
