//
//  File.swift
//
//
//  Created by X Tommy on 2022/10/12.
//

import Foundation
import Web3MQNetworking

struct RegisterRequest: Web3MQRequest {

    typealias Response = EmptyDataResponse

    var method: HTTPMethod = .post

    var path: String = "/api/pubkey"

    var parameters: [String: Any]? {
        [
            "userid": registerParameters.userId,
            "pubkey": registerParameters.publicKey,
            "metamask_signature": registerParameters.metaMaskSignature,
            "sign_content": registerParameters.signContent,
            "wallet_address": registerParameters.walletAddress,
            "wallet_type": registerParameters.walletType,
            "timestamp": registerParameters.timestamp,
            "app_key": registerParameters.appKey,
        ]
    }

    let registerParameters: RegisterParameter

    init(registerParameters: RegisterParameter) {
        self.registerParameters = registerParameters
    }
}
