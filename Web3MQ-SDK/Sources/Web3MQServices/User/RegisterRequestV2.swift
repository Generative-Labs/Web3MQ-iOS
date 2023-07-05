//
//  File.swift
//
//
//  Created by X Tommy on 2023/1/3.
//

import CryptoKit
import Foundation
import Web3MQNetworking

public struct RegisterResult {
    public let userId: String
    public let did: DID
    public let privateKey: Curve25519.Signing.PrivateKey
}

public struct RegisterResponse: Decodable {
    public let userId: String
    public let didValue: String
    public let didType: String

    public var did: DID {
        DID(type: didType, value: didValue)
    }

    enum CodingKeys: String, CodingKey {
        case userId = "userid"
        case didValue = "did_value"
        case didType = "did_type"
    }
}

struct RegisterRequestV2: Web3MQRequest {

    typealias Response = RegisterResponse

    var method: HTTPMethod = .post

    var path: String = "/api/user_register_v2/"

    var signer: ParameterSigner? = nil

    var parameters: [String: Any]? {
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
