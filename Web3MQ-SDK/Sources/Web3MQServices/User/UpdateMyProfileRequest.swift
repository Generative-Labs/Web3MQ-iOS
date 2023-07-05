//
//  UpdateMyProfileRequest.swift
//
//
//  Created by X Tommy on 2022/10/31.
//

import Foundation
import Web3MQNetworking

struct UpdateMyProfileRequest: Web3MQRequest {

    typealias Response = UserProfile

    var method: HTTPMethod = .post

    var path: String = "/api/my_profile/"

    let nickname: String
    let avatarUrl: String?

    var parameters: Parameters? {
        var temp: [String: String] = [:]
        temp["nickname"] = nickname
        temp["avatar_url"] = avatarUrl
        return temp
    }

    init(nickname: String, avatarUrl: String?) {
        self.nickname = nickname
        self.avatarUrl = avatarUrl
    }

}
