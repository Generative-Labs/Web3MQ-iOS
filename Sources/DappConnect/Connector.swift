//
//  ConnectClient.swift
//
//
//  Created by X Tommy on 2023/1/10.
//

import Combine
import CryptoKit
import CryptoSwift
import UIKit
import Web3MQNetworking

public struct DappMQUser {

    public let privateKey: Curve25519.Signing.PrivateKey

    public let topic: String

}

public protocol Connector {

    var connectionStatusPublisher: AnyPublisher<ConnectionStatus, Never> { get }

    var requestPublisher: AnyPublisher<Request, Never> { get }

    var responsePublisher: AnyPublisher<Response, Never> { get }

    var sessionDeletePublisher: AnyPublisher<Session, Never> { get }

    var sessionUpdatePublisher:
        AnyPublisher<
            (
                sessionTopic: String,
                namespace: [String: SessionNamespace]
            ), Never
        >
    { get }

    var currentURL: URL? { get }

    //    /// Connect websocket
    //    @discardableResult
    //    func connect(url: URL?, topic: String, privateKey: Curve25519.Signing.PrivateKey) async throws -> NodeId

    /// Depend on `Session
    @discardableResult
    func send<T: Codable>(content: T, topic: String) async throws -> Web3MQMessage

    @discardableResult
    func send<T: Codable>(
        content: T,
        topic: String,
        peerPublicKeyHex: String,
        privateKey: Curve25519.Signing.PrivateKey
    ) async throws -> Web3MQMessage

    func connect(user: DappMQUser) async throws

    func disconnect()

}

///
public class DappMQConnector: Connector {
    
    public var currentURL: URL? {
        webSocket.currentURL
    }

    let webSocket: WebSocketClient

    let serializer: Serializer

    ///
    let appId: String

    ///
    let metadata: AppMetadata

    private var url: URL?

    private var nodeId: NodeId?

    private var user: DappMQUser?

    ///
    public required init(
        appId: String,
        url: URL? = nil,
        metadata: AppMetadata,
        websocket: WebSocketClient = WebSocketManager(),
        serializer: Serializer = Serializer()
    ) {
        self.appId = appId
        self.metadata = metadata
        self.url = url
        self.serializer = serializer
        self.webSocket = websocket
        bindEvents()
    }

    public func connect(user: DappMQUser) async throws {
        self.nodeId = try await webSocket.bridgeConnect(
            url: url,
            nodeId: nil,
            appId: appId,
            topic: user.topic,
            privateKey: user.privateKey)
        self.user = user
    }

    var subscriptions: Set<AnyCancellable> = []

    public var requestPublisher: AnyPublisher<Request, Never> {
        requestSubject.eraseToAnyPublisher()
    }

    public var responsePublisher: AnyPublisher<Response, Never> {
        responseSubject.eraseToAnyPublisher()
    }

    public var sessionDeletePublisher: AnyPublisher<Session, Never> {
        sessionDeleteSubject.eraseToAnyPublisher()
    }

    public var sessionUpdatePublisher:
        AnyPublisher<(sessionTopic: String, namespace: [String: SessionNamespace]), Never>
    {
        sessionUpdateSubject.eraseToAnyPublisher()
    }

    private let requestSubject = PassthroughSubject<Request, Never>()
    private let responseSubject = PassthroughSubject<Response, Never>()
    private let sessionDeleteSubject = PassthroughSubject<Session, Never>()
    private let sessionUpdateSubject = PassthroughSubject<
        (sessionTopic: String, namespace: [String: SessionNamespace]), Never
    >()

    private let messageSubject = PassthroughSubject<DappMQMessage, Never>()

    typealias BridgeUrl = String

    private let concurrentQueue = DispatchQueue(
        label: "com.webemq.sdk.dappmq.connector", attributes: .concurrent)

    public var connectionStatusPublisher: AnyPublisher<ConnectionStatus, Never> {
        connectionStatusSubject.eraseToAnyPublisher()
    }

    public let connectionStatusSubject = CurrentValueSubject<ConnectionStatus, Never>(.idle)

    public func disconnect() {
        webSocket.disconnect(source: .user) {}
        user = nil
    }

    /// Sends content as `message.payload.content`
    public func send<T: Codable>(content: T, topic: String) async throws -> Web3MQMessage {
        guard let session = DappMQSessionStorage.shared.getSession(forTopic: topic) else {
            throw DappMQError.invalidSession
        }

        guard let user else {
            throw DappMQError.userDisconnect
        }

        return try await send(
            content: content,
            topic: topic,
            peerPublicKeyHex: session.peerParticipant.publicKey,
            privateKey: user.privateKey)
    }

    public func send<T: Codable>(
        content: T,
        topic: String,
        peerPublicKeyHex: String,
        privateKey: Curve25519.Signing.PrivateKey
    ) async throws -> Web3MQMessage {

        let encrypted = try serializer.encrypt(
            content, peerPublicKeyHexString: peerPublicKeyHex, privateKey: privateKey)
        let publicKeyHexString = privateKey.publicKeyHexString
        let payload = DappMQMessagePayload(content: encrypted, publicKey: publicKeyHexString)
        let userId = Web3MQDefaultUserIdGenerator.userId(
            appId: appId, publicKeyBase64String: privateKey.publicKeyBase64String)

        // check if ws connect before send data
        try await waitingForConnect()

        return try await webSocket.send(
            payload,
            topicId: topic,
            userId: userId,
            privateKey: privateKey)
    }

}

// MARK: - Basics

extension DappMQConnector {

    ///
    public func createURI(
        request: SessionProposalRPCRequest, privateKey: Curve25519.Signing.PrivateKey
    ) -> DappMQURI {
        let topic = Web3MQDefaultUserIdGenerator.userId(
            appId: appId, publicKeyBase64String: privateKey.publicKeyBase64String)
        return DappMQURI(
            topic: topic,
            proposer: Participant(publicKey: privateKey.publicKeyHexString, appMetadata: metadata),
            request: request)
    }

    private func waitingForConnect() async throws {
        try await withUnsafeThrowingContinuation({
            (continuation: UnsafeContinuation<Void, Error>) in
            var cancellable: AnyCancellable?
            cancellable = webSocket.connectionStatusSubject
                .setFailureType(to: TimeoutError.self)
                .timeout(.seconds(20), scheduler: concurrentQueue, customError: TimeoutError.init)
                .filter { $0.isConnected }
                .prefix(1)
                .sink { completion in
                    switch completion {
                    case .failure(let error):
                        cancellable?.cancel()
                        continuation.resume(throwing: error)
                    case .finished:
                        break
                    }
                } receiveValue: { _ in
                    cancellable?.cancel()
                    continuation.resume()
                }
        })
    }

}

// MARK: - Receives Message

extension DappMQConnector {

    private func bindEvents() {
        webSocket.messagePublisher
            .filter { $0.messageType == Web3MQMessageType.bridge.rawValue }
            .sink { [weak self] message in
                guard let payload: DappMQMessagePayload = message.decodePayload() else {
                    return
                }
                let dappMQMessage = DappMQMessage(payload: payload, fromTopic: message.comeFrom)
                self?.onReceiveMessage(dappMQMessage)
            }.store(in: &subscriptions)

        webSocket.connectionStatusSubject
            .sink { [weak self] status in
                self?.connectionStatusSubject.send(status)
            }.store(in: &subscriptions)

    }

    private func onReceiveMessage(_ message: DappMQMessage) {
        messageSubject.send(message)
        if let rpcRequest: RPCRequest = try? serializer.decode(
            content: message.payload.content,
            peerPublicKeyHexString: message.payload.publicKey)
        {
            let request = Request(
                rpcRequest: rpcRequest,
                topic: message.fromTopic,
                publicKey: message.payload.publicKey)
            requestSubject.send(request)
        } else if let rpcResponse: RPCResponse = try? serializer.decode(
            content: message.payload.content,
            peerPublicKeyHexString: message.payload.publicKey)
        {
            let response = Response(
                rpcResponse: rpcResponse,
                topic: message.fromTopic,
                publicKey: message.payload.publicKey)
            responseSubject.send(response)
        }
    }

}
