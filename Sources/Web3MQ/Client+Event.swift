//
//  File.swift
//
//
//  Created by X Tommy on 2023/3/1.
//

import Foundation
import Web3MQNetworking
import Web3MQServices

struct Web3MQUserProvider: UserProvider {

    var publicKey: String? {
        ChatClient.`default`.user?.publicKeyHex
    }

    var didType: String? {
        ChatClient.`default`.user?.did.type
    }

    var didValue: String? {
        ChatClient.`default`.user?.did.value
    }
}

extension ChatClient {

    func bindEvents(for websocket: WebSocketClient) {

        HeaderAdapter.default.userProvider = Web3MQUserProvider()

        registerInterceptors([StorageInterceptor()])

        websocket
            .notificationPublisher
            .sink { [weak self] notifications in
                self?.notificationSubject.send(notifications)
                self?.update(notifications: notifications)
            }.store(in: &subscriptions)

        websocket
            .messagePublisher
            .receive(on: DispatchQueue.global())
            .sink { [unowned self] message in
                Task {
                    try await self.onUpdateMessage(message)
                }
            }.store(in: &subscriptions)

        websocket
            .messageStatusPublisher
            .sink { [unowned self] statusItem in
                self.messageStatusSubject.send(statusItem)
            }.store(in: &subscriptions)

        websocket.connectionStatusSubject.sink { [weak self] status in
            self?.connectionStatusSubject.send(status)
            if case .connected(let nodeId, _) = status {
                self?.onConnected(nodeId: nodeId)
            } else if case .disconnected(let source) = status {
                self?.onDisconnect(source: source)
            }
        }.store(in: &subscriptions)

    }

    // receives node id
    private func onConnected(nodeId: String?) {
        guard let user else {
            return
        }
        service.client.session?.nodeId = nodeId
        CurrentUserRepository.saveCurrentUser(
            userId: user.userId,
            privateKey: user.sessionKey,
            didValue: user.did.value,
            didType: user.did.type,
            context: persistentContainer.writableContext)
    }

    private func onDisconnect(source: ConnectionStatus.DisconnectionSource) {
        if source == .user {
            user = nil
        }
        service.client.session?.nodeId = nil
    }

    func refreshChats() {
        let chats = ChannelRepository.fetchAllChannel(context: persistentContainer.writableContext)
        channelsSubject.send(chats)
    }

    private func onUpdateMessage(_ message: Web3MQMessage) async throws {
        let finalMessage = try await self.interceptors.asyncReduce(
            message, { try await $1.handle(message: $0) })
        messageSubject.send(finalMessage)
        MessageRepository.insertMessage(
            message: Message(web3mqMessage: message), context: persistentContainer.writableContext)
        refreshChats()
    }

    private func onUpdateMessageStatus(_ messageStatusItem: Web3MQMessageStatusItem) async throws {
        try await self.interceptors.asyncForEach({
            try await $0.handleMessageStatusUpdate(status: messageStatusItem)
        })
    }

    private func update(notifications: [NotificationMessage]) {
        Task {
            let ids = notifications.filter({ $0.read == false }).map { $0.messageID }
            _ = try await service.updateNotificationStatus(
                ids, status: .delivered)
        }
    }

}

extension Web3MQMessage {

    func toMessage() -> Message {
        Message(web3mqMessage: self)
    }
}

extension MessageDTO {

    func toMessage() -> Message {
        Message(
            cipherSuite: cipherSuite ?? "NONE",
            from: user?.id ?? "",
            topic: topicId ?? "",
            messageId: id ?? "",
            timestamp: Int(updatedAt?.millisecondsSince1970 ?? 0),
            payload: text?.data(using: .utf8)?.base64EncodedString() ?? "",
            messageStatus: Message.Status(
                status: MessageStatus(rawValue: messageStatus?.status ?? ""),
                timestamp: Int(messageStatus?.timestamp?.timeIntervalSince1970 ?? 0) * 1000))
    }

}
