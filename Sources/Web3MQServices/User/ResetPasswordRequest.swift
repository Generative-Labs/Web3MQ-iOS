//
//  ResetPasswordRequest.swift
//
//
//  Created by X Tommy on 2023/1/5.
//

import Foundation
import Web3MQNetworking

struct ResetPasswordRequest: Web3MQRequest {

    typealias Response = RegisterResponse

    var method: HTTPMethod = .post

    var path: String = "/api/user_reset_password_v2/"

    var parameters: Parameters? {
        var param: [String: Any] = [
            "testnet_access_key": registerParameters.accessKey,
            "userid": registerParameters.userId,
            "did_type": registerParameters.didType,
            "did_value": registerParameters.didValue,
            "did_signature": registerParameters.didSignature,
            "signature_content": registerParameters.signatureRaw,
            "pubkey_value": registerParameters.pubKeyValue,
            "pubkey_type": registerParameters.pubKeyType,
            "timestamp": registerParameters.timestamp,
        ]
        param["nickename"] = registerParameters.nickname
        param["avatar_url"] = registerParameters.avatarUrl
        return param
    }

    let registerParameters: RegisterParameterV2

    init(registerParameters: RegisterParameterV2) {
        self.registerParameters = registerParameters
    }

}
