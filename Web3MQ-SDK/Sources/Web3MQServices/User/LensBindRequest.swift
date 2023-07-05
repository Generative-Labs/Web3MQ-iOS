//
//  LensBindRequest.swift
//
//
//  Created by X Tommy on 2022/11/6.
//

import Foundation
import Web3MQNetworking

struct LensBindRequest: Web3MQRequest {

    typealias Response = EmptyDataResponse

    var method: HTTPMethod = .post

    var path: String = "/api/bind_userdid/"

    let didValue: String

    var signContent: String? {
        "lens.xyz" + didValue
    }

    var parameters: Parameters? {
        ["provider_id": "web3mq:lens:xyz", "did_type": "lens.xyz", "did_value": didValue]
    }

}
