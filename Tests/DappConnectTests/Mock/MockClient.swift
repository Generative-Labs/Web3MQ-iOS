//
//  MockClient.swift
//
//
//  Created by X Tommy on 2023/2/6.
//

import Combine
import CryptoKit
import Foundation

@testable import DappConnect
@testable import Web3MQNetworking

class MockDappMQClient: DappConnectClient {

    let peerPrivateKey = Curve25519.Signing.PrivateKey()

    required init(
        appId: String, metadata: AppMetadata, endpoint: URL? = nil, keyStorage: KeyStorage? = nil,
        connector: Connector? = nil, requestIdGenerator: IdGenerator? = nil
    ) {
        super.init(
            appId: appId, metadata: metadata, endpoint: endpoint, keyStorage: keyStorage,
            connector: connector, requestIdGenerator: requestIdGenerator)
    }

    func messageForApproveSessionProposal(
        proposalId: String,
        sessionNamespace: [String: SessionNamespace]
    ) async throws -> Web3MQMessage {
        let result = RPCResult.response(
            AnyCodable(
                SessionNamespacesResult(
                    sessionNamespaces: sessionNamespace,
                    metadata: AppMetadata(name: "", description: "", url: "", icons: [""]))))
        let content = RPCResponse(
            id: proposalId, method: RequestMethod.providerAuthorization, outcome: result)
        let peerPublicKeyHex = keyStorage.privateKey.publicKeyHexString
        return try await connector.send(
            content: content, topic: "test_topic_id", peerPublicKeyHex: peerPublicKeyHex,
            privateKey: peerPrivateKey)
    }

    func messageForRejectSessionProposal(proposalId: String) async throws -> Web3MQMessage {
        let result = RPCResult.error(
            RPCError(code: 5001, message: "User disapproved requested methods"))
        let content = RPCResponse(
            id: proposalId, method: RequestMethod.providerAuthorization, outcome: result)
        return try await messageForContent(content)
    }

    func messageForPersonalSign(requestId: String, signature: String) async throws -> Web3MQMessage
    {
        let result = RPCResult.response(AnyCodable(signature))
        let content = RPCResponse(
            id: requestId, method: RequestMethod.personalSign, outcome: result)
        return try await messageForContent(content)
    }

    private func messageForContent(_ content: RPCResponse) async throws -> Web3MQMessage {
        let peerPublicKeyHex = keyStorage.privateKey.publicKeyHexString
        return try await connector.send(
            content: content, topic: "test_topic_id", peerPublicKeyHex: peerPublicKeyHex,
            privateKey: peerPrivateKey)
    }

}
