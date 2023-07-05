//
//  FriendOffersInRequest.swift
//
//
//  Created by X Tommy on 2022/11/1.
//

import Foundation
import Web3MQNetworking

struct FriendOffersInRequest: Web3MQRequest {

    typealias Response = ContactUser

    var method: HTTPMethod = .get

    var path: String = "/api/contacts/friend_requests_list/"

    let pageCount: Int
    let pageSize: Int

}
