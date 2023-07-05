//
//  ConnectResult.swift
//  Web3MQDemo
//
//  Created by X Tommy on 2022/10/19.
//

import CryptoKit
import Foundation

///
public struct DID: Codable {

    ///
    public let type: String

    ///
    public let value: String

    ///
    public init(type: String, value: String) {
        self.type = type
        self.value = value
    }
}

public struct RegisterParameter {

    let userId: String
    let publicKey: String
    let metaMaskSignature: String
    let signContent: String
    let walletAddress: String
    let walletType: String
    let timestamp: UInt64

    var appKey: String = ""

}

public struct RegisterParameterV2 {

    var accessKey: String = ""

    let userId: String
    let didType: String
    let didValue: String
    let didSignature: String
    let signatureRaw: String
    let pubKeyValue: String
    let pubKeyType: String
    let timestamp: UInt64
    let nickname: String?
    let avatarUrl: String?

    public init(
        accessKey: String, userId: String, didType: String, didValue: String, didSignature: String,
        signatureRaw: String, pubKeyValue: String, pubKeyType: String, timestamp: UInt64,
        nickname: String?, avatarUrl: String?
    ) {
        self.accessKey = accessKey
        self.userId = userId
        self.didType = didType
        self.didValue = didValue
        self.didSignature = didSignature
        self.signatureRaw = signatureRaw
        self.pubKeyValue = pubKeyValue
        self.pubKeyType = pubKeyType
        self.timestamp = timestamp
        self.nickname = nickname
        self.avatarUrl = avatarUrl
    }

}

public enum LoginError: Error {

    case privateKeyNotInLocalStorage

    case invalidResponseCode(message: String?)
}
