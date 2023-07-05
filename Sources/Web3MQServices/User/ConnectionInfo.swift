//
//  User.swift
//
//
//  Created by X Tommy on 2023/3/7.
//

import Foundation

/// A login session, you can keep this session to connect `Web3MQ`
public protocol ConnectionInfo {

    ///
    var userId: String { get }

    ///
    var did: DID { get }

    ///
    var sessionKey: String { get }

}

extension ConnectionInfo {

    public var publicKeyHex: String? {
        try? KeyPair(sessionKey).publicKeyString
    }

}

public struct ConnectUser: ConnectionInfo {

    public let userId: String

    public let did: DID

    public let sessionKey: String

    public init(userId: String, did: DID, sessionKey: String) {
        self.userId = userId
        self.did = did
        self.sessionKey = sessionKey
    }
}
