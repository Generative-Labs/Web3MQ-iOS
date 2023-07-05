//
//  ContactsSearchRequest.swift
//
//
//  Created by X Tommy on 2022/11/1.
//

import Foundation
import Web3MQNetworking

struct ContactsSearchRequest: Web3MQRequest {

    typealias Response = ContactUser

    var method: HTTPMethod = .get

    var path: String = "/api/contacts/search/"

    let keyword: String

    var signContent: String? {
        keyword
    }

    var parameters: Parameters? {
        ["keyword": keyword]
    }

}
