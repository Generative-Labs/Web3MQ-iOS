//
//  Web3MQService+User.swift
//
//
//  Created by X Tommy on 2023/3/2.
//

import CryptoKit
import CryptoSwift
import Foundation
import Web3MQNetworking

extension Wallet {

    var didType: String {
        // TODO: relate to `chainId`
        return "eth"
    }

}

extension Web3MQService {

    /// Searches user by a keyword
    public func searchUsers(keyword: String) async throws -> Page<UserInfo> {
        try await client.send(
            request: SearchUsersRequest(keyword: keyword)
        ).page ?? Page.empty()
    }

    /// Gets the user info by didType and didValue
    /// if throws error, that means user not exist
    public func userInfo(didType: String, didValue: String) async throws -> UserInfo? {
        do {
            return try await client.send(
                request: GetUserInfoRequest(didType: didType, didValue: didValue)
            ).data
        } catch Web3MQNetworkingError.responseFailed {
            return nil
        } catch {
            throw error
        }
    }

    /// Gets the user info by didType and didValue, if user not exist, then generate a userId.
    public func getOrGenerateUserId(for didType: String, didValue: String) async throws -> String {
        let userInfo = try await userInfo(didType: didType, didValue: didValue)
        if let userId = userInfo?.userId {
            return userId
        } else {
            let raw = (didType + ":" + didValue).sha3(.sha224)
            return "user:\(raw)"
        }
    }

    /// Gets the current user's profile
    public func profile() async throws -> UserProfile {
        guard
            let response =
                try await client
                .send(request: GetMyProfileRequest()).data
        else {
            throw Web3MQNetworkingError.responseFailed(reason: .dataEmpty)
        }
        return response
    }

    ///
    public func publicProfile(userId: String, didType: String, didValue: String) async throws
        -> UserProfile
    {
        guard
            let response =
                try await client
                .send(
                    request: GetPublicProfileRequest(
                        userId: userId, didType: didType, didValue: didType)
                ).data
        else {
            throw Web3MQNetworkingError.responseFailed(reason: .dataEmpty)
        }
        return response
    }

    ///
    public func userPermissions(userId: String) async throws -> UserPermissions {
        guard
            let response =
                try await client
                .send(request: UserPermissionsRequest(targetUserId: userId)).data,
            let permissions = response.permissions
        else {
            throw Web3MQNetworkingError.responseFailed(reason: .dataEmpty)
        }
        return permissions
    }

    ///
    public func changeProfile(nickName: String, avatarUrl: String? = nil)
        async throws -> UserProfile
    {
        guard
            let response = try await client.send(
                request: UpdateMyProfileRequest(
                    nickname: nickName, avatarUrl: avatarUrl)
            ).data
        else {
            throw Web3MQNetworkingError.responseFailed(reason: .dataEmpty)
        }
        return response
    }

}

extension Web3MQService {

    public func register(did: DID, password: String) async throws -> RegisterResult {
        guard let walletConnector else {
            throw Web3MQServiceError.emptyWalletConnector
        }

        let didType = did.type
        let didValue = did.value

        let privateKey = try await fetchPrivateKey(did: did, password: password)
        let publicKeyHex = privateKey.publicKey.rawRepresentation.toHexString()

        let userId = try await getOrGenerateUserId(for: didType, didValue: didValue)

        // TODO: didType -> walletType
        let walletTypeName = "Ethereum"
        let pubKeyType = "ed25519"

        let currentDate = Date()
        let timestamp = currentDate.millisecondsSince1970

        let domainUrl = "www.web3mq.com"

        let nonceContentRaw =
            "\(userId)\(pubKeyType)\(publicKeyHex)\(didType)\(didValue)\(timestamp)"
        let nonceContent = nonceContentRaw.sha3(.sha224)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        let formattedDateString = dateFormatter.string(from: currentDate)

        let signatureRaw = """
            Web3MQ wants you to sign in with your \(walletTypeName) account:
            \(didValue)
            For Web3MQ register
            URI: \(domainUrl)
            Version: 1

            Nonce: \(nonceContent)
            Issued At: \(formattedDateString)
            """

        let signature = try await walletConnector.personalSign(
            message: signatureRaw, address: didValue, password: nil)
        let response = try await register(
            userId: userId, didType: didType, didValue: didValue, publicKeyHex: publicKeyHex,
            signatureRaw: signatureRaw, signature: signature, timestamp: timestamp)
        return RegisterResult(userId: response.userId, did: response.did, privateKey: privateKey)
    }

    /// Fetches main private key.
    public func fetchPrivateKey(did: DID, password: String) async throws
        -> Curve25519.Signing.PrivateKey
    {
        guard let walletConnector else {
            throw Web3MQServiceError.emptyWalletConnector
        }

        let message = signRawForMainPrivateKey(did: did, password: password)
        let signature = try await walletConnector.personalSign(
            message: message,
            address: did.value, password: nil)
        print("debug:signature:\(signature)")
        let bytes = signature.bytes.sha256()
        return try Curve25519.Signing.PrivateKey(rawRepresentation: bytes)
    }

    private func signRawForMainPrivateKey(did: DID, password: String) -> String {
        let walletType = did.type
        let walletAddress = did.value
        let keyIndex = 1
        let password = password
        let keyMSG = "\(walletType):\(walletAddress)\(keyIndex)\(password)"
        let magicString = "$web3mq\(keyMSG)web3mq$".bytes.sha3(.sha224).toHexString().bytes
            .toBase64()

        return """
            Signing this message will allow this app to decrypt messages in the Web3MQ protocol for the following address: \(walletAddress). This won’t cost you anything.

            If your Web3MQ wallet-associated password and this signature is exposed to any malicious app, this would result in exposure of Web3MQ account access and encryption keys, and the attacker would be able to read your messages.

            In the event of such an incident, don’t panic. You can call Web3MQ’s key revoke API and service to revoke access to the exposed encryption key and generate a new one!

            Nonce: \(magicString)
            """
    }

    private func register(
        userId: String,
        didType: String,
        didValue: String,
        publicKeyHex: String,
        signatureRaw: String,
        signature: String,
        timestamp: UInt64
    ) async throws -> RegisterResponse {

        guard let appKey else {
            throw Web3MQServiceError.emptyAppKey
        }

        let registerParameters = RegisterParameterV2(
            accessKey: appKey,
            userId: userId,
            didType: didType,
            didValue: didValue,
            didSignature: signature,
            signatureRaw: signatureRaw,
            pubKeyValue: publicKeyHex,
            pubKeyType: "ed25519",
            timestamp: timestamp,
            nickname: nil,
            avatarUrl: nil)

        guard
            let response = try await client.send(
                request: RegisterRequestV2(registerParameters: registerParameters)
            ).data
        else {
            throw Web3MQNetworkingError.responseFailed(reason: .dataEmpty)
        }
        return response

    }

    /// Gets a user with its `DID` and password, also with an duration for expired.
    public func user(
        did: DID,
        password: String,
        expiredDuration: TimeInterval = 7 * 86400 * 1000
    ) async throws -> ConnectionInfo {
        let privateKey = try await fetchPrivateKey(did: did, password: password)
        print("debug:mainPrivateKeyHex:\(privateKey.rawRepresentation.toHexString())")
        return try await user(did: did, privateKey: privateKey, expiredDuration: expiredDuration)
    }

    /// Gets a user with its `DID` and privateKey, also with an duration for expired.
    public func user(
        did: DID,
        privateKey: Curve25519.Signing.PrivateKey,
        expiredDuration: TimeInterval = 7 * 86400 * 1000
    ) async throws -> ConnectionInfo {

        let userId = try await getOrGenerateUserId(for: did.type, didValue: did.value)
        let mainPublicKeyHex = privateKey.publicKey.rawRepresentation.toHexString()

        let tempKeyPair = KeyPair.generate()
        let tempPublicKeyHex = tempKeyPair.publicKeyString

        let timestamp = Date().millisecondsSince1970
        let publicKeyExpiredTimestamp = timestamp + UInt64(expiredDuration)
        let signatureRaw =
            userId + tempPublicKeyHex + "\(publicKeyExpiredTimestamp)" + "\(timestamp)"
        let signatureContent = signatureRaw.sha3(.sha224)

        let signatureData = try privateKey.signature(for: signatureContent.bytes)
        let signature = signatureData.base64EncodedString()
        let response = try await client.send(
            request: LoginRequestV2(
                userId: userId,
                didType: did.type,
                didValue: did.value,
                signature: signature,
                signatureRaw: signatureContent,
                mainPublicKey: mainPublicKeyHex,
                publicKey: tempPublicKeyHex,
                publicKeyType: "ed25519",
                timestamp: timestamp,
                publicKeyExpiredTimestamp: publicKeyExpiredTimestamp))

        return ConnectUser(
            userId: response.data?.userId ?? "",
            did: did,
            sessionKey: tempKeyPair.privateKeyString)

    }

}
