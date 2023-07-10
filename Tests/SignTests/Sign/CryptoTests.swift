//
//  SignTests.swift
//
//
//  Created by X Tommy on 2023/1/28.
//

import CryptoKit
import XCTest

@testable import DappConnect

/// Crypto Tests
final class CryptoTests: XCTestCase {

    private var otherSidePublicKeyHexString: String!

    private var privateKeyHexString: String!

    override func setUpWithError() throws {
        otherSidePublicKeyHexString =
            "8820A1E05E5CDFDB96AE25CAE90F2B4F914E642E19FE46ACA5B1ED1CC5FA550D"
        privateKeyHexString = "FC7C969E6492D1AF4F221CF492D1F6D6B37D5774A2BD7826CF95EEDD9E5234B3"
    }

    func testSharedKeyGenerate() throws {
        let symmetricKey = try SignUtils.symmetricKeyWithEd25519(
            publicKeyHex: otherSidePublicKeyHexString, privateKeyHex: privateKeyHexString)
        let symmetricKeyHex = symmetricKey.withUnsafeBytes { Data($0).toHexString() }

        XCTAssertEqual(
            symmetricKeyHex.uppercased(),
            "F891FCF10A97F43CAE2B31A87D65FC3F06CEDDDDAE6BE71ADAAAA0E096789FFC")

        let privateKey0 = Curve25519.Signing.PrivateKey()
        let privateKeyHex0 = privateKey0.rawRepresentation.toHexString()
        let publicKey0 = privateKey0.publicKey
        let publicKeyHex0 = publicKey0.rawRepresentation.toHexString()

        let privateKey1 = Curve25519.Signing.PrivateKey()
        let privateKeyHex1 = privateKey1.rawRepresentation.toHexString()
        let publicKey1 = privateKey1.publicKey
        let publicKeyHex1 = publicKey1.rawRepresentation.toHexString()

        let symmetricKey0 = try SignUtils.symmetricKeyWithEd25519(
            publicKeyHex: publicKeyHex0, privateKeyHex: privateKeyHex1)
        let symmetricKey0Base64 = symmetricKey0.withUnsafeBytes { Data($0).toHexString() }

        let symmetricKey1 = try SignUtils.symmetricKeyWithEd25519(
            publicKeyHex: publicKeyHex1, privateKeyHex: privateKeyHex0)
        let symmetricKey1Base64 = symmetricKey1.withUnsafeBytes { Data($0).toHexString() }

        XCTAssertEqual(symmetricKey1Base64, symmetricKey0Base64)

    }

    func testEncrypt() throws {
        let bytes = Data(hex: privateKeyHexString)
        let privateKey = try Curve25519.Signing.PrivateKey(rawRepresentation: bytes)
        let shareKeyCoder = DappMQShareKeyCoder()
        let encrypted = try shareKeyCoder.encryptData(
            "aaa".bytes,
            peerPublicKeyHexString: otherSidePublicKeyHexString,
            privateKey: privateKey)
        XCTAssertEqual(encrypted, "nfg3+s9cni++B3TQwnwMamD5fw==")
    }

    func testDecrypt() throws {
        let bytes = Data(hex: privateKeyHexString)
        let privateKey = try Curve25519.Signing.PrivateKey(rawRepresentation: bytes)
        let shareKeyCoder = DappMQShareKeyCoder()
        let decodedData = try shareKeyCoder.decodeToData(
            content: "nfg3+s9cni++B3TQwnwMamD5fw==",
            peerPublicKeyHexString: otherSidePublicKeyHexString,
            privateKey: privateKey)
        let decoded = String(data: decodedData, encoding: .utf8)
        XCTAssertEqual(decoded, "aaa")
    }

}
