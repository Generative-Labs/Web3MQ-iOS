//
//  RequestIdGenerator.swift
//
//
//  Created by X Tommy on 2023/1/19.
//

import CryptoKit
import CryptoSwift
import Foundation

///
public protocol IdGenerator {

    ///
    func nextId() -> String
}

///
public struct Web3MQDefaultRequestIdGenerator: IdGenerator {

    public func nextId() -> String {
        let timestamp = Int64(Date().timeIntervalSince1970 * 1000) * 1000
        let random = Int64.random(in: 0..<1000)
        return String(random + timestamp)
    }

}

///
enum Web3MQDefaultUserIdGenerator {

    static func userId(appId: String, publicKeyBase64String: String) -> String {
        "bridge:" + (appId + "@" + publicKeyBase64String).sha1()
    }

}
