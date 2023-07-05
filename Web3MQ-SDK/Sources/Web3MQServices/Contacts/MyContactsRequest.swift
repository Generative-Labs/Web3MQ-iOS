//
//  File.swift
//
//
//  Created by X Tommy on 2022/11/1.
//

import Foundation
import Web3MQNetworking

/// Get the Contacts
struct MyContactsRequest: Web3MQRequest {

    typealias Response = ContactUser

    var method: HTTPMethod = .get

    var path: String = "/api/contacts/"

    var parameters: Parameters? {
        ["page": pageCount, "size": pageSize]
    }

    let pageCount: Int
    let pageSize: Int

}
