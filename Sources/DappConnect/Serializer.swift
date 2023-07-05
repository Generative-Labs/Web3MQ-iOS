//
//  Serializer.swift
//
//
//  Created by X Tommy on 2023/2/18.
//

import CryptoKit
import Foundation

public class Serializer {

    private let keyManager: KeyStorage

    private let shareKeyCoder: ShareKeyCoder

    public init(
        keyManager: KeyStorage = UserDefaultsKeyStorage.shared,
        shareKeyCoder: ShareKeyCoder = DappMQShareKeyCoder()
    ) {
        self.keyManager = keyManager
        self.shareKeyCoder = shareKeyCoder
    }

    func encrypt<T: Codable>(
        _ object: T,
        peerPublicKeyHexString: String,
        privateKey: Curve25519.Signing.PrivateKey?
    ) throws -> String {
        let privateKey = privateKey ?? keyManager.privateKey
        return try shareKeyCoder.encrypt(
            object, peerPublicKeyHexString: peerPublicKeyHexString, privateKey: privateKey)
    }

    func encryptData(
        _ data: [UInt8],
        peerPublicKeyHexString: String,
        privateKey: Curve25519.Signing.PrivateKey?
    ) throws -> String {
        let privateKey = privateKey ?? keyManager.privateKey
        return try shareKeyCoder.encryptData(
            data,
            peerPublicKeyHexString: peerPublicKeyHexString,
            privateKey: privateKey)
    }

    func decode<T: Codable>(
        content: String,
        peerPublicKeyHexString: String
    ) throws -> T {
        let privateKey = keyManager.privateKey
        return try shareKeyCoder.decode(
            content: content,
            peerPublicKeyHexString: peerPublicKeyHexString,
            privateKey: privateKey)
    }

    func decodeToData(
        content: String,
        peerPublicKeyHexString: String
    ) throws -> Data {
        let privateKey = keyManager.privateKey
        return try shareKeyCoder.decodeToData(
            content: content,
            peerPublicKeyHexString: peerPublicKeyHexString,
            privateKey: privateKey)
    }

}
