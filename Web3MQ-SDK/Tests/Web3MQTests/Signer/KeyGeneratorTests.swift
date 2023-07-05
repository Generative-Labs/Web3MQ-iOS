//
//  KeyGeneratorTests.swift
//
//
//  Created by X Tommy on 2022/12/7.
//

import CryptoKit
import XCTest

@testable import Web3MQNetworking

final class KeyGeneratorTests: XCTestCase {

    func testKeyPairGenerate() throws {
        let keyPair = KeyGenerator.generateKeyPair()
        XCTAssertNotEqual(keyPair.publicKeyString, "")
        XCTAssertNotEqual(keyPair.privateKeyString, "")
    }

    func testKeyPairSign() throws {
        let text = "hello,world"
        let data = text.data(using: .utf8)!
        let keyPair = KeyGenerator.generateKeyPair()
        let signature = try keyPair.privateKey.signature(for: text.bytes)
        let isValid = keyPair.publicKey.isValidSignature(signature, for: data)
        XCTAssertTrue(isValid)
    }

    func testGenerateRadomKey() throws {
        let key = KeyGenerator.generateRandomKey()
        XCTAssertNotNil(key)
    }

    func testKeyGeneratePerformance() throws {
        self.measure {
            _ = KeyGenerator.generateKeyPair()
        }
    }

}
