//
//  KeyManager.swift
//
//
//  Created by X Tommy on 2023/2/17.
//

import Combine
import CryptoKit
import Foundation

public protocol KeyStorage {

    var privateKey: Curve25519.Signing.PrivateKey { get }

    func savePrivateKey(data: Data)

    func clear()
}

public final class UserDefaultsKeyStorage: KeyStorage {

    lazy var storage = UserDefaults.standard

    private let key = "ed255.data"

    private var subscriptions: Set<AnyCancellable> = []

    public static let shared = UserDefaultsKeyStorage()
    private init() {
        //
        privateKeyCreateSubject.sink { [weak self] privateKey in
            self?.savePrivateKey(data: privateKey.rawRepresentation)
        }.store(in: &subscriptions)
    }

    let privateKeyCreateSubject = PassthroughSubject<Curve25519.Signing.PrivateKey, Never>()

    /// Once you create a new privateKey, that will clean all data on session.
    public func savePrivateKey(data: Data) {
        // keychain[data: key] = data
        storage.set(data, forKey: key)

        DappMQSessionStorage.shared.removeAll()
        DappMQSessionProposalStorage.shared.removeAll()
        RecordStorage.shared.removeAll()
    }

    private var _privateKey: Curve25519.Signing.PrivateKey?

    public var privateKey: Curve25519.Signing.PrivateKey {
        if let _privateKey {
            return _privateKey
        }

        if let data = storage.data(forKey: key),
            let key = try? Curve25519.Signing.PrivateKey(rawRepresentation: data)
        {
            _privateKey = key
            return key
        } else {
            let key = generatePrivateKey()
            _privateKey = key
            return key
        }
    }

    public func clear() {
        _privateKey = nil
        storage.removeObject(forKey: key)
    }

    private func generatePrivateKey() -> Curve25519.Signing.PrivateKey {
        let key = Curve25519.Signing.PrivateKey()
        defer { privateKeyCreateSubject.send(key) }
        return key
    }
}
