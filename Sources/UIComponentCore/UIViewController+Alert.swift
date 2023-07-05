//
//  UIViewController+Alert.swift
//  
//
//  Created by X Tommy on 2023/1/17.
//

import UIKit

public extension UIViewController {
    
    func showToast(_ message: String, title: String? = nil) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alertController, animated: true)
        }
    }
    
    func presentAlertWithTextField(title: String? = nil, message: String) async -> String? {
        await withUnsafeContinuation({ continuation in
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addTextField()
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                continuation.resume(returning: nil)
            }))
            alertController.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { _ in
                let text = alertController.textFields?.first?.text
                continuation.resume(returning: text)
            }))
            self.present(alertController, animated: true)
        })
    }
    
}
