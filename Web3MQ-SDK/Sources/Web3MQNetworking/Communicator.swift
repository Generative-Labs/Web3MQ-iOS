//
//  Communicator.swift
//
//
//  Created by X Tommy on 2022/10/11.
//

import Combine
import CryptoKit
import Foundation
import Starscream

/////
//public protocol Communicator {
//
//    /// The current `KeyPair`which connects web3mq
//    var keyPair: KeyPair? { get }
//
//    /// The current user id which connects web3mq
//    var userId: String? { get }
//
//    /// Connect to the Web3MQ websocket
//    func connect(keyPair: KeyPair, userId: String) async throws -> NodeId
//
//    /// Sends messages to a certain chat destination on behalf of the current user.
//    func sendMessage(text: String,
//                     topicId: String,
//                     nodeId: String,
//                     type: Web3MQMessageType) async throws -> Web3MQMessage
//
//    /// Sends messages to a certain chat destination on behalf of the current user.
//    func sendMessage(payload: Data,
//                     topicId: String,
//                     nodeId: String,
//                     type: Web3MQMessageType) async throws -> Web3MQMessage
//
//    func send<T: Web3MQRequest>(request: T) async throws -> Web3MQResponse<T.Response>
//
//    /// Disconnects from the current websocket
//    func disconnect()
//
//    /// The publisher that can get connection status
//    var connectionStatusSubject: CurrentValueSubject<ConnectionStatus, Never> { set get }
//
//    /// The publisher for receive notifications
//    var notificationPublisher: AnyPublisher<[NotificationMessage], Never> { get }
//
//    /// The publisher for receiving message
//    var messageReceivedPublisher: AnyPublisher<Web3MQMessage, Never> { get }
//
//    /// The publisher for sending message
//    var messageSentPublisher: AnyPublisher<Web3MQMessage, Never> { get }
//
//    /// The publisher for message status updating
//    var messageStatusPublisher: AnyPublisher<Web3MQMessageStatusItem, Never> { get }
//
//}
//
/////
//public final class Web3MQCommunicator: Communicator {
//
//    public var keyPair: KeyPair?
//
//    public var userId: String?
//
//    public var nodeId: String?
//
//    private var httpClient: HTTPClient
//
//    private var webSocketClient: WebSocketClient
//
//    public init(httpClient: HTTPClient = Web3MQHTTPClient(), webSocketClient: WebSocketClient = WebSocketManager()) {
//        self.httpClient = httpClient
//        self.webSocketClient = webSocketClient
//    }
//
//    public var notificationPublisher: AnyPublisher<[NotificationMessage], Never> {
//        notificationSubject.eraseToAnyPublisher()
//    }
//
//    public var messageReceivedPublisher: AnyPublisher<Web3MQMessage, Never> {
//        messageSubject.eraseToAnyPublisher()
//    }
//
//    public var messageSentPublisher: AnyPublisher<Web3MQMessage, Never> {
//        messageSentSubject.eraseToAnyPublisher()
//    }
//
//    public var messageStatusPublisher: AnyPublisher<Web3MQMessageStatusItem, Never> {
//        messageStatusSubject.eraseToAnyPublisher()
//    }
//
//    public var connectionStatusSubject = CurrentValueSubject<ConnectionStatus, Never>(.idle)
//
//    let notificationSubject = PassthroughSubject<[NotificationMessage], Never>()
//    let messageSubject = PassthroughSubject<Web3MQMessage, Never>()
//    let messageStatusSubject = PassthroughSubject<Web3MQMessageStatusItem, Never>()
//    let messageSentSubject = PassthroughSubject<Web3MQMessage, Never>()
//
//    var subscriptions: Set<AnyCancellable> = []
//
//    /// Connect to the Web3MQ websocket
//    @discardableResult
//    public func connect(keyPair: KeyPair, userId: String) async throws -> NodeId {
//        self.keyPair = keyPair
//        self.userId = userId
//
//        bindEvents(for: webSocketClient)
//        return try await webSocketClient.connect(url: nil,
//                                                 nodeId: nil,
//                                                 userId: userId,
//                                                 privateKey: keyPair.privateKey)
//    }
//
//    /// Sends messages to a certain chat destination on behalf of the current user.
//    public func sendMessage(text: String,
//                            topicId: String,
//                            nodeId: String,
//                            type: Web3MQMessageType) async throws
//    -> Web3MQMessage {
//        try await sendMessage(content: text,
//                              topicId: topicId,
//                              nodeId: nodeId,
//                              type: type)
//    }
//
//    /// Sends messages to a certain chat destination on behalf of the current user.
//    public func sendMessage(payload: Data,
//                            topicId: String,
//                            nodeId: String,
//                            type: Web3MQMessageType) async throws -> Web3MQMessage {
//        try await sendMessage(content: payload,
//                              topicId: topicId,
//                              nodeId: nodeId,
//                              type: type
//        )
//    }
//
//    /// Sends bridge messages to a certain chat destination on behalf of the current user.
//    public func sendBridgeMessage(payload: Data,
//                                  topicId: String,
//                                  nodeId: String) async throws {
//        _ = try await sendMessage(
//            content: payload,
//            topicId: topicId,
//            nodeId: nodeId,
//            type: Web3MQMessageType.walletBridge)
//    }
//
//    private func sendMessage(
//        content: Any,
//        topicId: String,
//        nodeId: String,
//        type: Web3MQMessageType,
//        cipherSuite: String = "NONE"
//    ) async throws -> Web3MQMessage {
//        guard let userId,
//              let keyPair else {
//            throw Web3MQNetworkingError.sendMessageFailed(reason: .disconnected)
//        }
//        let message = try await webSocketClient.sendMessage(content: content,
//                                                     topicId: topicId,
//                                                     messageType: type,
//                                                     cipherSuite: cipherSuite,
//                                                     userId: userId,
//                                                     privateKey: keyPair.privateKey)
//        defer {
//            messageSentSubject.send(message)
//        }
//        return message
//    }
//
//    public func send<T>(request: T) async throws -> Web3MQResponse<T.Response> where T : Web3MQRequest {
//        try await httpClient.send(request: request)
//    }
//
//    /// Disconnects the websocket
//    public func disconnect() {
//        webSocketClient.disconnect(source: .user) { }
//    }
//
//    deinit {
//        NotificationCenter.default.removeObserver(self)
//    }
//
//    private func bindEvents(for websSocket: WebSocketClient) {
//
//        websSocket.connectionStatusSubject.sink { [weak self] status in
//            self?.connectionStatusSubject.send(status)
//        }.store(in: &subscriptions)
//
//        websSocket.notificationPublisher.sink { [weak self] messages in
//            self?.notificationSubject.send(messages)
//        }.store(in: &subscriptions)
//
//        websSocket.messagePublisher.sink { [weak self] message in
//            self?.messageSubject.send(message)
//        }.store(in: &subscriptions)
//
//        websSocket.messageStatusPublisher.sink { [weak self] item in
//            self?.messageStatusSubject.send(item)
//        }.store(in: &subscriptions)
//
//        websSocket.connectionStatusSubject.sink { [weak self] status in
//            self?.connectionStatusSubject.send(status)
//            switch status {
//            case .connected(let nodeId):
//                Web3MQParameterSigner.shared.privateKey = self?.keyPair?.privateKey
//                Web3MQParameterSigner.shared.userId = self?.userId
//                self?.nodeId = nodeId
//            case .disconnected(_ ):
//                Web3MQParameterSigner.shared.privateKey = nil
//                Web3MQParameterSigner.shared.userId = nil
//                self?.nodeId = nil
//            default: break
//            }
//        }.store(in: &subscriptions)
//
//    }
//
//}
//
