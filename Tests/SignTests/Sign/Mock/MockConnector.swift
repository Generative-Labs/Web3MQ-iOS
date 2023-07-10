//
//  MockWebSocket.swift
//
//
//  Created by X Tommy on 2023/2/6.
//

import Combine
import CryptoKit
import Foundation

@testable import DappConnect
@testable import Web3MQNetworking

class MockTimeoutConnector: DappMQConnector {

    override func connect(user: DappMQUser) async throws {
        throw TimeoutError()
    }

}

class MockConnector: DappMQConnector {

    required init(
        appId: String, url: URL? = nil, metadata: AppMetadata,
        websocket: WebSocketClient = WebSocketManager(), serializer: Serializer = Serializer()
    ) {
        super.init(
            appId: appId, url: url, metadata: metadata, websocket: websocket, serializer: serializer
        )
    }

    //    let connectionStatusSubject = CurrentValueSubject<Web3MQNetworking.ConnectionStatus, Never>(.idle)

    //    var connectionStatusPublisher: AnyPublisher<Web3MQNetworking.ConnectionStatus, Never> {
    //        connectionStatusSubject.eraseToAnyPublisher()
    //    }

    //    let requestSubject = PassthroughSubject<DappMQ.Request, Never>()
    //
    //    var requestPublisher: AnyPublisher<DappMQ.Request, Never> {
    //        requestSubject.eraseToAnyPublisher()
    //    }
    //
    let newResponseSubject = PassthroughSubject<DappConnect.Response, Never>()
    //
    override
        var responsePublisher: AnyPublisher<DappConnect.Response, Never>
    {
        newResponseSubject.eraseToAnyPublisher()
    }

    override func send<T>(
        content: T, topic: String, peerPublicKeyHex: String,
        privateKey: Curve25519.Signing.PrivateKey
    ) async throws -> Web3MQMessage where T: Decodable, T: Encodable {
        return Web3MQMessage()
    }

    override func send<T>(content: T, topic: String) async throws -> Web3MQMessage
    where T: Decodable, T: Encodable {
        return Web3MQMessage()
    }

    override
    func connect(user: DappMQUser) async throws
    {
        try await Task.sleep(nanoseconds: 100_000_000)
        connectionStatusSubject.send(Web3MQNetworking.ConnectionStatus.connected(nodeId: "nodeID"))
    }

    override
        func disconnect()
    {
        connectionStatusSubject.send(
            Web3MQNetworking.ConnectionStatus.disconnected(
                source: ConnectionStatus.DisconnectionSource.user))
    }

    func makeConnectSuccess(with requestId: String) async throws {
        let result = RPCResult.response(
            AnyCodable(
                SessionNamespacesResult(
                    sessionNamespaces: Mocks.emptySessionNamespace,
                    metadata: Mocks.appMetadata)))
        let rpcResponse = RPCResponse(
            id: requestId, method: RequestMethod.providerAuthorization, outcome: result)
        let response = Response(rpcResponse: rpcResponse, topic: "", publicKey: "")
        newResponseSubject.send(response)
    }

    func makeConnectError(with requestId: String) async throws {
        let result = RPCResult.error(
            RPCError(code: 5001, message: "User disapproved requested methods"))
        let rpcResponse = RPCResponse(
            id: requestId, method: RequestMethod.providerAuthorization, outcome: result)
        let response = Response(rpcResponse: rpcResponse, topic: "", publicKey: "")
        newResponseSubject.send(response)
    }

    func makePersonalSignResponse(with requestId: String, signature: String) async throws {
        let result = RPCResult.response(
            AnyCodable(signature))
        let rpcResponse = RPCResponse(
            id: requestId, method: RequestMethod.personalSign, outcome: result)
        let response = Response(rpcResponse: rpcResponse, topic: "", publicKey: "")
        newResponseSubject.send(response)
    }

}
