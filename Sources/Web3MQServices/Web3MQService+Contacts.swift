//
//  Web3MQService+Contacts.swift
//
//
//  Created by X Tommy on 2023/3/2.
//

import Foundation
import Web3MQNetworking

extension Web3MQService {

    public func follow(
        action: FollowAction, targetUserId: String, didType: String, didSignature: String,
        didPublicKey: String?, signContent: String, message: String?, timestamp: Int
    ) async throws {
        guard let userId = client.session?.userId else {
            throw Web3MQNetworkingError.requestFailed(reason: .keyPairEmpty)
        }
        _ = try await client.send(
            request: FollowRequest(
                action: action, userId: userId, targetUserId: targetUserId, didType: didType,
                didSignature: didSignature, didPublicKey: didPublicKey, signRaw: signContent,
                message: message, timestamp: timestamp))
    }

    public func followingList(pageCount: Int, pageSize: Int) async throws -> Page<FollowUser> {
        try await client.send(
            request: FollowingListRequest(
                pageCount: pageCount,
                pageSize: pageSize)
        ).page ?? Page.empty()
    }

    public func followersList(pageCount: Int, pageSize: Int) async throws -> Page<FollowUser> {
        try await client.send(
            request: FollowersListRequest(
                pageCount: pageCount,
                pageSize: pageSize)
        ).page ?? Page.empty()
    }

    public func followContacts(
        pageCount: Int,
        pageSize: Int
    ) async throws -> Page<FollowUser> {
        try await client.send(
            request: ContactsRequest(
                pageCount: pageCount,
                pageSize: pageSize)
        ).page ?? Page.empty()
    }

    /// Makes a friend request
    public func makeFriendRequest(to targetUserId: String, message: String) async throws {
        _ = try await client.send(
            request: AddFriendsRequest(userId: targetUserId, message: message))
    }

    public func agreeFriendRequest(userId: String) async throws {
        _ = try await client.send(
            request: FriendOfferActionRequest(action: .agree, targetUserId: userId))
    }

    public func follow(targetUserId: String, message: String?) async throws {
        try await doFollow(action: .follow, targetUserId: targetUserId, message: message)
    }

    public func unfollow(targetUserId: String) async throws {
        try await doFollow(action: .unfollow, targetUserId: targetUserId, message: nil)
    }

    private func doFollow(action: FollowAction, targetUserId: String, message: String?) async throws
    {
        guard let walletConnector else {
            throw Web3MQServiceError.emptyWalletConnector
        }

        let walletInfo = try await walletConnector.connectWallet()
        let walletType = walletInfo.walletType
        let walletAddress = walletInfo.address

        let user = try await userInfo(didType: walletType, didValue: walletAddress)
        guard let userId = user?.userId else {
            throw Web3MQServiceError.userInfoNotExist
        }

        let walletTypeName = walletType.walletTypeDescription

        let currentDate = Date()
        let timestamp = currentDate.millisecondsSince1970

        let nonceContentRaw = "\(userId)\(action)\(targetUserId)\(timestamp)"
        let nonceContent = nonceContentRaw.sha3(.sha224)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        let formattedDateString = dateFormatter.string(from: currentDate)

        let signatureRaw = """
            Web3MQ wants you to sign in with your \(walletTypeName) account:
            \(walletAddress)

            For follow signature

            Nonce: \(nonceContent)
            Issued At: \(formattedDateString)`;
            """

        let signature = try await walletConnector.personalSign(
            message: signatureRaw,
            address: walletAddress,
            password: nil)

        try await follow(
            action: action,
            targetUserId: targetUserId,
            didType: walletType,
            didSignature: signature,
            didPublicKey: user?.publicKey,
            signContent: signatureRaw,
            message: message,
            timestamp: Int(timestamp))
    }

}

extension Wallet {

    var walletType: String {
        guard let firstAccountString = accounts.first,
            let account = Account(firstAccountString)
        else {
            return "eth"
        }
        return account.walletType
    }

    var address: String {
        guard let firstAccountString = accounts.first,
            let account = Account(firstAccountString)
        else {
            return ""
        }
        return account.address
    }

}

extension Account {

    var walletType: String {
        switch self.namespace {
        case "eip155": return "eth"
        case "SN_GOERLI": return "starknet"
        default:
            return ""
        }
    }
}

extension String {

    var walletTypeDescription: String {
        switch self {
        case "eth": return "Ethereum"
        case "starknet": return "Starknet"
        default: return ""
        }
    }
}

struct Account: Equatable, Hashable {

    let namespace: String

    let reference: String

    let address: String

    var blockchainIdentifier: String {
        "\(namespace):\(reference)"
    }

    var absoluteString: String {
        "\(namespace):\(reference):\(address)"
    }

    init?(_ string: String) {
        guard string.isConformsToCAIP10 else { return nil }
        let splits = string.split(separator: ":")
        self.namespace = String(splits[0])
        self.reference = String(splits[1])
        self.address = String(splits[2])
    }
}

extension Account: LosslessStringConvertible {
    var description: String {
        return absoluteString
    }
}

extension Account: Codable {

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let absoluteString = try container.decode(String.self)
        guard let account = Account(absoluteString) else {
            throw DecodingError.dataCorruptedError(
                in: container, debugDescription: "Malformed CAIP-10 account identifier.")
        }
        self = account
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(absoluteString)
    }
}

extension String {

    static let chainNamespaceRegex = "^[-a-z0-9]{3,8}$"
    static let chainReferenceRegex = "^[-a-zA-Z0-9]{1,32}$"
    static let accountAddressRegex = "^[a-zA-Z0-9]{1,64}$"

    var isConformsToCAIP10: Bool {
        let splits = self.split(separator: ":", omittingEmptySubsequences: false)
        guard splits.count == 3 else { return false }
        let namespace = splits[0]
        let reference = splits[1]
        let address = splits[2]
        let isNamespaceValid =
            (namespace.range(of: String.chainNamespaceRegex, options: .regularExpression) != nil)
        let isReferenceValid =
            (reference.range(of: String.chainReferenceRegex, options: .regularExpression) != nil)
        let isAddressValid =
            (address.range(of: String.accountAddressRegex, options: .regularExpression) != nil)
        return isNamespaceValid && isReferenceValid && isAddressValid
    }

}
