//
//  FriendOffersOutRequest.swift
//
//
//  Created by X Tommy on 2022/11/1.
//

import Foundation
import Web3MQNetworking

struct FriendOffersOutRequest: Web3MQRequest {

    typealias Response = ContactUser

    var method: HTTPMethod = .get

    var path: String = "/api/contacts/add_friends_list/"

    let pageCount: Int
    let pageSize: Int

}
