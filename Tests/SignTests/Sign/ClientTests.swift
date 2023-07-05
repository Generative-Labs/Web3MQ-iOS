//
//  ClientTests.swift
//
//
//  Created by X Tommy on 2023/2/6.
//

import CryptoKit
import XCTest

@testable import DappMQ

final class ClientTests: XCTestCase {

    var connector: MockConnector!
    var timeoutConnector: MockTimeoutConnector!

    var dappClient: MockDappMQClient!
    var timeoutSignClient: MockDappMQClient!

    var dAppPrivateKey: Curve25519.Signing.PrivateKey!

    var walletPrivateKey: Curve25519.Signing.PrivateKey!

    var dAppTopicId: String!

    var walletTopicId: String!

    var appMetadata: AppMetadata!

    override func setUpWithError() throws {

        walletTopicId = "test_wallet_topic_id"
        dAppTopicId = "test_dapp_topic_id"
        dAppPrivateKey = Curve25519.Signing.PrivateKey()

        walletPrivateKey = Curve25519.Signing.PrivateKey()

        appMetadata = AppMetadata(name: "", description: "", url: "", icons: [""])

        let dappId = "SwapChat:im"

        connector = MockConnector(appId: dAppTopicId, metadata: appMetadata)
        timeoutConnector = MockTimeoutConnector(appId: dAppTopicId, metadata: appMetadata)

        dappClient = MockDappMQClient(
            appId: dappId,
            metadata: appMetadata,
            connector: connector)

        timeoutSignClient = MockDappMQClient(
            appId: dappId,
            metadata: appMetadata,
            connector: timeoutConnector)

        DappMQConfiguration.timeoutInterval = 2

    }

    ///
    func testConnectWalletApprove() async throws {
        try await withThrowingTaskGroup(of: Void.self) { group in
            let requestId = "test_request_id"
            group.addTask {
                let session = try await self.dappClient.connectWallet(
                    requiredNamespaces: Mocks.emptyProposalNamespace, proposalId: requestId)
                XCTAssertEqual(session.proposalId, requestId)
            }
            group.addTask {
                try await Task.sleep(nanoseconds: 1_000_000_000)
                try await self.connector.makeConnectSuccess(with: requestId)
            }
            try await group.waitForAll()
        }
    }

    func testConnectWalletNotApprove() async throws {
        try await withThrowingTaskGroup(of: Void.self) { group in
            let requestId = "test_request_id"
            group.addTask {
                do {
                    let _ = try await self.dappClient.connectWallet(
                        requiredNamespaces: Mocks.emptyProposalNamespace, proposalId: requestId)
                } catch {
                    XCTAssertNotNil(error)
                }
            }
            group.addTask {
                try await Task.sleep(nanoseconds: 1_000_000_000)
                try await self.connector.makeConnectError(with: requestId)
            }
            try await group.waitForAll()
        }
    }

    ///
    func testConnectWalletTimeout() async throws {
        DappMQConfiguration.timeoutInterval = 2

        try await withThrowingTaskGroup(of: Void.self) { group in
            let requestId = "test_request_id"
            group.addTask {
                do {
                    _ = try await self.dappClient.connectWallet(
                        requiredNamespaces: Mocks.emptyProposalNamespace, proposalId: requestId)
                } catch {
                    XCTAssertNotNil(error)
                }
            }
            group.addTask {
                try await Task.sleep(nanoseconds: 3_000_000_000)
            }
            try await group.waitForAll()
        }
    }

    func testSendingSignResponse() async throws {

        DappMQConfiguration.timeoutInterval = 2

        let connectRequestId = "test_request_id"
        let message = "hello,world"
        let signature = "hello, world, signed"
        let signRequestId = "test_request_id"

        try await withThrowingTaskGroup(of: Void.self) { group in
            group.addTask {
                let connectResponse = try await self.dappClient.connectWallet(
                    requiredNamespaces: Mocks.emptyProposalNamespace, proposalId: connectRequestId)
                XCTAssertEqual(connectResponse.proposalId, connectRequestId)
                let signResponse = try await self.dappClient.personalSign(
                    message: message, address: "0x1", password: nil, topic: connectResponse.topic)
                XCTAssertNotNil(signResponse)
            }

            group.addTask {
                try await Task.sleep(nanoseconds: 500_000_000)
                try await self.connector.makeConnectSuccess(with: connectRequestId)
                try await Task.sleep(nanoseconds: 500_000_000)
                try await self.connector.makePersonalSignResponse(
                    with: signRequestId, signature: signature)
            }

            try await group.waitForAll()
        }
    }

    func testCleanup() async throws {
        let connectRequestId = "test_connect_request_id"
        await withThrowingTaskGroup(
            of: Void.self,
            body: { group in
                group.addTask {
                    let connectResponse = try await self.dappClient.connectWallet(
                        requiredNamespaces: Mocks.emptyProposalNamespace,
                        proposalId: connectRequestId)
                    XCTAssertEqual(connectResponse.proposalId, connectRequestId)
                }

                group.addTask {
                    try await Task.sleep(nanoseconds: 100_000_000)
                    try await self.connector.makeConnectSuccess(with: connectRequestId)
                }
            })

        XCTAssertNotNil(dappClient.sessions)
        dappClient.cleanup()
        XCTAssertEqual(dappClient.sessions.count, 0)
    }

}

enum Mocks {

    /// An empty session namespaces for tests.
    static let emptySessionNamespace: [String: SessionNamespace] = [
        "": SessionNamespace(
            accounts: Set([
                Account(
                    blockchain: Blockchain(namespace: "eip155", reference: "1")!, address: "0x0000")!
            ]), methods: Set([""]), events: Set([""]))
    ]

    static let emptyProposalNamespace: [String: ProposalNamespace] = [
        "": ProposalNamespace(
            chains: [Blockchain(namespace: "eip155", reference: "1")!], methods: Set([""]),
            events: Set([""]))
    ]

    static let appMetadata = AppMetadata(
        name: "mock_app_name", description: "mock_description", url: "mock_url",
        icons: ["mock_icon_0", "mock_icon_1"])

}
