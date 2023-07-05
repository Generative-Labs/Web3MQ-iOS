//
//  SyncKeyPairAlertView.swift
//
//
//  Created by X Tommy on 2022/10/21.
//

import UIKit

public class SyncKeyPairAlertView {

    public var userId: String
    public var code: String
    public weak var fromViewController: UIViewController?

    public init(userId: String, code: String, fromViewController: UIViewController) {
        self.userId = userId
        self.fromViewController = fromViewController
        self.code = code
    }

    private var continuation: UnsafeContinuation<Bool, Never>?

    @MainActor public func present() async -> Bool {
        let alertController = UIAlertController(
            title: "Web3MQ Sign In Requested\ncode:\(self.code)",
            message: "Your Web3MQ ID is being used to sign in\nuser ID:\(self.userId)",
            preferredStyle: .alert)

        alertController.addAction(
            UIAlertAction(
                title: "Don't Allow",
                style: .default,
                handler: { _ in
                    self.continuation?.resume(returning: false)
                }))

        alertController.addAction(
            UIAlertAction(
                title: "Allow",
                style: .default,
                handler: { _ in
                    self.continuation?.resume(returning: true)
                }))

        self.fromViewController?.present(alertController, animated: true)

        return await withUnsafeContinuation { continuation in
            self.continuation = continuation
        }
    }

}
