//
//  FriendOfferActionRequest.swift
//
//
//  Created by X Tommy on 2022/11/1.
//

import Foundation
import Web3MQNetworking

struct FriendOfferActionRequest: Web3MQRequest {

    enum Action: String {
        case agree
    }

    typealias Response = EmptyDataResponse

    var method: HTTPMethod = .post

    var path: String = "/api/contacts/friend_requests/"

    let action: Action
    let targetUserId: String

    var parameters: Parameters? {
        ["target_userid": targetUserId, "action": action.rawValue]
    }

    var signContent: String? {
        action.rawValue + targetUserId
    }

}
