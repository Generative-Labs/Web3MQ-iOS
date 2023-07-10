//
//  MockSignClient.swift
//
//
//  Created by X Tommy on 2023/2/6.
//

import Foundation

@testable import DappConnect

class MockDappMQClient: DappConnectClient {

    required init(appId: String, metadata: AppMetadata, endpoint: URL? = nil, keyStorage: KeyStorage? = nil, connector: Connector? = nil, requestIdGenerator: IdGenerator? = nil) {
        super.init(appId: appId, metadata: metadata, endpoint: endpoint, keyStorage: keyStorage, connector: connector, requestIdGenerator: requestIdGenerator)
    }
}

class MockRequestIdGenerator: IdGenerator {
    func nextId() -> String {
        return "test_request_id"
    }
}
