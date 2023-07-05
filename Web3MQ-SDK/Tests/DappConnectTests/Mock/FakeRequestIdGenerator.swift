//
//  File.swift
//
//
//  Created by X Tommy on 2023/2/6.
//

import DappMQ
import Foundation

class FakeRequestIdGenerator: IdGenerator {

    private var staticRequestId: String

    init(staticRequestId: String) {
        self.staticRequestId = staticRequestId
    }

    func nextId() -> String {
        staticRequestId
    }

}
