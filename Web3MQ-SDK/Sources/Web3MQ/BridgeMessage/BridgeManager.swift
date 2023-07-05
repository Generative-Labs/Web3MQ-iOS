//
//  BridgeManager.swift
//
//
//  Created by X Tommy on 2022/10/13.
//

import Combine
import Foundation
import Web3MQNetworking

public protocol BridgeMessageHandler {

    func registerHandlers(_ bridgeEventHandlers: [BridgeEventHandler])
}

///
public class BridgeManager: BridgeMessageHandler {

    private var subscriptions: Set<AnyCancellable> = []

    private var handlers: [BridgeEventHandler] = []

    ///
    public var nodeId: String?

    init() {
        //        HTTPClient
        //            .bridgeMessagePublisher
        //            .sink { [unowned self] message in
        //                self.onReceiveBridgeMessage(message)
        //            }.store(in: &subscriptions)
    }

    ///
    public func registerHandlers(_ bridgeEventHandlers: [BridgeEventHandler]) {
        handlers.append(contentsOf: bridgeEventHandlers)
    }

}

extension BridgeManager {

    private func onReceiveBridgeMessage(_ message: Web3MQMessage) {
        handlers.forEach { handler in
            if handler.shouldHandle(event: message) {
                Task {
                    if let result = await handler.handle(event: message) {
                        try? await sendMessage(result, topicId: message.comeFrom)
                    }
                }
            }
        }
    }

    private func sendMessage(_ payload: Data, topicId: String) async throws {
        //        guard let nodeId else {
        //            return
        //        }
        ////        try await HTTPClient.sendBridgeMessage(payload: payload,
        //                                                              topicId: topicId,
        //                                                              nodeId: nodeId)
    }

}
