//
//  File.swift
//
//
//  Created by X Tommy on 2022/10/31.
//

import Foundation
import Web3MQNetworking

struct SearchUsersRequest: Web3MQRequest {

    typealias Response = UserInfo

    var method: HTTPMethod = .get

    var path: String = "/api/users/search/"

    var parameters: Parameters? {
        ["keyword": keyword]
    }

    var signContent: String? {
        keyword
    }

    let keyword: String

    init(keyword: String) {
        self.keyword = keyword
    }

}
