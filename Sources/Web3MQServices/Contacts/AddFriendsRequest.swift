//
//  File.swift
//
//
//  Created by X Tommy on 2022/11/1.
//

import Foundation
import Web3MQNetworking

struct AddFriendsRequest: Web3MQRequest {

    var signedParameters: Parameters? = nil

    typealias Response = EmptyDataResponse

    var method: HTTPMethod = .post

    var path: String = "/api/contacts/add_friends/"

    let userId: String

    let message: String

    var parameters: Parameters? {
        ["target_userid": userId, "content": message]
    }

    var signContent: String? {
        userId + message
    }

    init(userId: String, message: String) {
        self.userId = userId
        self.message = message
    }

}
