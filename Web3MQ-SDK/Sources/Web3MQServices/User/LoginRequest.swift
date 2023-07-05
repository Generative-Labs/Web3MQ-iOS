//
//  LoginRequest.swift
//
//
//  Created by X Tommy on 2022/10/18.
//

import Foundation
import Web3MQNetworking

struct LoginRequest: Web3MQRequest {

    typealias Response = EmptyDataResponse

    var method: HTTPMethod = .post

    var path: String = "/api/user_login/"

    var parameters: Parameters? {
        [
            "userid": userId,
            "did_type": didType,
            "did_value": didValue,
            "did_signature": didSignature,
            "pubkey_value": publicKey,
            "pubkey_type": "ed25519",
            "timestamp": timestamp,
            "signature_content": signatureContent,
            "testnet_access_key": accessKey,
        ]
    }

    let userId: String
    let didType: String
    let didValue: String
    let didSignature: String
    let publicKey: String
    let signatureContent: String
    let accessKey: String
    let timestamp: UInt64

    init(
        method: HTTPMethod, path: String, userId: String, didType: String, didValue: String,
        didSignature: String, publicKey: String, signatureContent: String, accessKey: String,
        timestamp: UInt64
    ) {
        self.method = method
        self.path = path
        self.userId = userId
        self.didType = didType
        self.didValue = didValue
        self.didSignature = didSignature
        self.publicKey = publicKey
        self.signatureContent = signatureContent
        self.accessKey = accessKey
        self.timestamp = timestamp
    }

}

public struct LoginResponse: Decodable {
    public let userId: String
    public let didValue: String
    public let didType: String

    enum CodingKeys: String, CodingKey {
        case userId = "userid"
        case didValue = "did_value"
        case didType = "did_type"
    }

}

struct LoginRequestV2: Web3MQRequest {

    typealias Response = LoginResponse

    var method: HTTPMethod = .post

    var path: String = "/api/user_login_v2/"

    let userId: String
    let didType: String
    let didValue: String
    let signature: String
    let signatureRaw: String
    let mainPublicKey: String
    let publicKey: String
    let publicKeyType: String
    let timestamp: UInt64
    let publicKeyExpiredTimestamp: UInt64

    var parameters: Parameters? {
        [
            "userid": userId,
            "did_type": didType,
            "did_value": didValue,
            "login_signature": signature,
            "signature_content": signatureRaw,
            "main_pubkey": mainPublicKey,
            "pubkey_value": publicKey,
            "pubkey_type": publicKeyType,
            "timestamp": timestamp,
            "pubkey_expired_timestamp": publicKeyExpiredTimestamp,
        ]
    }

    init(
        userId: String, didType: String, didValue: String, signature: String, signatureRaw: String,
        mainPublicKey: String, publicKey: String, publicKeyType: String, timestamp: UInt64,
        publicKeyExpiredTimestamp: UInt64
    ) {
        self.userId = userId
        self.didType = didType
        self.didValue = didValue
        self.signature = signature
        self.signatureRaw = signatureRaw
        self.mainPublicKey = mainPublicKey
        self.publicKey = publicKey
        self.publicKeyType = publicKeyType
        self.timestamp = timestamp
        self.publicKeyExpiredTimestamp = publicKeyExpiredTimestamp
    }

}
