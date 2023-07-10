//
//  File.swift
//
//
//  Created by X Tommy on 2023/1/18.
//

import Combine
import UIKit
import Web3MQ

extension UIViewController {

    public func doTaskAfterConnects(store: inout Set<AnyCancellable>, task: @escaping () -> Void) {
        ChatClient.default.connectionStatusPublisher
            .filter({ status in
                if case .connected(_) = status {
                    return true
                }
                return false
            })
            .first()
            .sink { _ in
                task()
            }.store(in: &store)
    }

}
