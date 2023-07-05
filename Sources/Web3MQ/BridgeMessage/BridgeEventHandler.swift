//
//  BridgeEventHandler.swift
//
//
//  Created by X Tommy on 2022/10/14.
//

import Foundation
import Web3MQNetworking

public protocol BridgeEventHandler {

    /// If returns true, then ``handle(event:)`` will be called.
    func shouldHandle(event: Web3MQMessage) -> Bool

    /// Handles the event, and returns a Data which will be send to the same topic
    /// - Parameter event: Web3MQMessage
    /// - Returns: a receipt which will be sent to the same topic
    func handle(event: Web3MQMessage) async -> Data?

}
