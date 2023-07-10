//
//  Web3MQClient.swift
//
//
//  Created by X Tommy on 2022/10/11.
//

import Combine
import CoreData
import CryptoKit
import Foundation
import Web3MQNetworking
import Web3MQServices

extension ChatClient {

    /// The default instance of the client. Use this instance to interact with the Web3MQ SDK.
    public static let `default` = ChatClient(
        service: Web3MQService(), websocket: WebSocketManager())

}

/// A `Web3MQ` chat client.
public class ChatClient {

    /// Receives and sends messages, etc.
    public let bridgeManager = BridgeManager()

    /// current connected user
    public var user: ConnectionInfo?

    public private(set) var configuration: Configuration?

    /// The publisher that emits the connection status.
    public var connectionStatusPublisher: AnyPublisher<ConnectionStatus, Never> {
        connectionStatusSubject.eraseToAnyPublisher()
    }

    /// The publisher that emits the message status.
    public var notificationPublisher: AnyPublisher<[NotificationMessage], Never> {
        notificationSubject.eraseToAnyPublisher()
    }

    /// The publisher that emits messages.
    public var messagePublisher: AnyPublisher<Web3MQMessage, Never> {
        messageSubject.eraseToAnyPublisher()
    }
    
    public var messageStatusPublisher: AnyPublisher<Web3MQMessageStatusItem, Never> {
        messageStatusSubject.eraseToAnyPublisher()
    }

    /// The subject that emits channels.
    public let channelsSubject = CurrentValueSubject<[ChannelItem], Never>([])

    /// The web3mq service.
    public private(set) var service: Service

    /// The websocket client.
    public private(set) var webSocket: WebSocketClient

    /// Creates a `ChatClient` instance with an given `Web3MQService` and `WebSocketClient`
    public init(
        service: Service = Web3MQService(),
        websocket: WebSocketClient = WebSocketManager()
    ) {
        self.service = service
        self.webSocket = websocket
        bindEvents(for: websocket)
    }

    let connectionStatusSubject = CurrentValueSubject<ConnectionStatus, Never>(.idle)

    let messageSubject = PassthroughSubject<Web3MQMessage, Never>()

    let messageStatusSubject = PassthroughSubject<Web3MQMessageStatusItem, Never>()

    let notificationSubject = CurrentValueSubject<[NotificationMessage], Never>([])

    var subscriptions: Set<AnyCancellable> = []

    /// Setup the current `ChatClient` instance.
    /// - Note:
    ///   Call this method before you access any other methods or properties in the Web3MQ SDK.
    public func setup(appKey: String) {
        configuration = Configuration(appKey: appKey)
        service.appKey = appKey
    }

    ///
    public var walletConnector: WalletConnector? {
        didSet {
            service.walletConnector = walletConnector
        }
    }

    public private(set) var interceptors: [Interceptor] = []

    public func registerInterceptors(_ interceptors: [Interceptor]) {
        self.interceptors.append(contentsOf: interceptors)
    }

    /// Connects to the Web3MQ with `User`
    public func connect(_ connectionInfo: ConnectionInfo) async throws -> NodeId {
        guard let _ = configuration else {
            throw Web3MQClientError.appKeyEmpty
        }

        let keyPair = try KeyPair(connectionInfo.sessionKey)

        self.user = connectionInfo

        // updates http session
        self.service.client.session = HTTPSession(
            userId: connectionInfo.userId,
            privateKey: keyPair.privateKey)

        return try await webSocket.connect(
            url: nil,
            nodeId: nil,
            userId: connectionInfo.userId,
            privateKey: keyPair.privateKey)
    }

    /// If the local database has personal information, call the connect method
    public func autoConnect() async throws -> NodeId {
        guard webSocket.connectionStatusSubject.value.isConnected == false,
            let user = CurrentUserRepository.currentUser(
                context: persistentContainer.writableContext),
            let privateKeyHex = user.privateKey,
            let userId = user.user?.id,
            let didType = user.didType,
            let didValue = user.didValue
        else {
            throw Web3MQClientError.autoConnectFailWithNoUserInCache
        }
        return try await connect(
            ConnectUser(
                userId: userId,
                did: DID(type: didType, value: didValue),
                sessionKey: privateKeyHex))
    }

    /// Disconnect from the web3mq websocket, and sets `keyPair` `userid` `nodeId` to nil.
    public func disconnect() {
        webSocket.disconnect(source: .user) {}
    }

    /// Disconnect from the web3mq websocket, and delete current user from the database if needed.
    public func logout() {
        disconnect()
        CurrentUserRepository.deleteUser(context: persistentContainer.writableContext)
    }

    /// Load the current user from the database.
    public func loadCurrentUserFromCache() -> CurrentUserPayload? {
        try? CurrentUserRepository.currentUser(context: persistentContainer.viewContext)?
            .asModel()
    }

}
