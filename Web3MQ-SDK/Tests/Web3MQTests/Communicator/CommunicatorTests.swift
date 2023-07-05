//
//  CommunicatorTests.swift
//
//
//  Created by X Tommy on 2022/12/7.
//

import Combine
import XCTest

@testable import Web3MQNetworking

final class CommunicatorTests: XCTestCase {

    private var subscriptions: Set<AnyCancellable> = []

    override func setUpWithError() throws {}

    func testConnect() throws {
        //        let wsUrl = "wss://dev-ap-jp-1.web3mq.com/messages"
        //        let keyPair = try KeyPair("0bf8eae8be0e7d364710ad1027598bb273e8122f75d4b70886f6ad855c03a991")
        //        let userId = "user:7c0b577c0786e51f90522f833bf8ac8749cb32d681e7eccedba1dcc45f9a5173"
        ////        XCTAssertNoThrow(try HTTPClient.connect(wsUrl, keyPair: keyPair, userId: userId))
        //
        //        let connectedExpectation = expectation(description: "connected")
        //
        //        HTTPClient
        //            .connectionStatusPublisher
        //            .sink { status in
        //                switch status {
        //                case .connected(let nodeId):
        //                    print("debug:tests:connected:nodeId:\(nodeId)")
        //                    connectedExpectation.fulfill()
        //                default: break
        //                }
        //            }.store(in: &subscriptions)
        //
        //        waitForExpectations(timeout: 5)
    }

}
