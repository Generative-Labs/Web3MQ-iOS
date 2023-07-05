//
//  Error.swift
//
//
//  Created by X Tommy on 2023/2/8.
//

import Foundation

///
public enum Web3MQClientError: Error {

    ///
    case walletConnectorIsNil

    /// Did not setup `appKey`
    /// call `ChatClient.default.setup(appKey: "")` to setup `appKey`
    case appKeyEmpty

    ///
    case autoConnectFailWithNoUserInCache

    ///
    case userEmpty

}
