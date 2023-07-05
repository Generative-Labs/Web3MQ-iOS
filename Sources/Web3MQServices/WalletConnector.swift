//
//  WalletConnector.swift
//
//
//  Created by X Tommy on 2023/2/7.
//

import Foundation

///
public protocol Wallet {

    /// Account IDs that follow the CAIP-10 standard.
    var accounts: [String] { get }

}

/// This protocol provides methods to connect a wallet and `personal_sign`
public protocol WalletConnector {

    ///
    func connectWallet() async throws -> Wallet

    ///
    func personalSign(
        message: String,
        address: String,
        password: String?
    ) async throws -> String

}
