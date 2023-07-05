////
////  RegisterManager.swift
////
////
////  Created by X Tommy on 2022/10/12.
////
//
//import Web3MQNetworking
//import CryptoSwift
//import Foundation
//import CryptoKit
//
//
//public struct RegisterManager {
//
//    public var appKey: String?
//
//    /// Gets the user info by didType and didValue
//    /// if throws error, that means user not exist
//    public func getUserInfo(didType: String, didValue: String) async throws -> UserInfo? {
//        try await Calendar.send(
//            request: GetUserInfoRequest(didType: didType, didValue: didValue)).data
//    }
//
//    /// Gets the user info by didType and didValue, if user not exist, then generate a userId.
//    public func getOrGenerateUserId(didType: String, didValue: String) async throws -> String {
//        let userInfo = try await getUserInfo(didType: didType, didValue: didValue)
//        if let userId = userInfo?.userId {
//            return userId
//        } else {
//            let raw = didType + didValue + String(Date().millisecondsSince1970)
//            return Digest.sha3(raw.bytes, variant: .sha224).toHexString()
//        }
//    }
//
////    public func resetPassword(didType: String,
////                              didValue: String,
////                              password: String,
////                              mainPrivateKeyBytes: Array<UInt8>,
////                              signatureRaw: String,
////                              signature: String,
////                              timestamp: UInt64) async throws -> RegisterResponse {
////        guard let appKey else {
////            throw Web3MQClientError.appKeyEmpty
////        }
////
////        let finalUserId = try await getOrGenerateUserId(didType: didType, didValue: didValue)
////
////        let privateKey = try Curve25519.Signing.PrivateKey(rawRepresentation: mainPrivateKeyBytes)
////        let publicKey = privateKey.publicKey.rawRepresentation.toHexString()
////
////        let registerParameters = RegisterParameterV2(accessKey: appKey,
////                                                     userId: finalUserId,
////                                                     didType: didType,
////                                                     didValue: didValue,
////                                                     didSignature: signature,
////                                                     signatureRaw: signatureRaw,
////                                                     pubKeyValue: publicKey,
////                                                     pubKeyType: "ed25519",
////                                                     timestamp: timestamp,
////                                                     nickname: nil,
////                                                     avatarUrl: nil)
////
////        guard let response = try await HTTPClient.send(
////            request: ResetPasswordRequest(registerParameters: registerParameters)).data else {
////            throw Web3MQNetworkingError.responseFailed(reason: .jsonEncodingFailed)
////        }
////        return response
////    }
//
//    public func register(
//        didType: String,
//        didValue: String,
//        password: String,
//        mainPrivateKeyBytes: Array<UInt8>,
//        signatureRaw: String,
//        signature: String,
//        timestamp: UInt64
//    ) async throws -> RegisterResponse {
//        guard let appKey else {
//            throw Web3MQClientError.appKeyEmpty
//        }
//
//        let finalUserId = try await getOrGenerateUserId(didType: didType, didValue: didValue)
//
//        let privateKey = try Curve25519.Signing.PrivateKey(rawRepresentation: mainPrivateKeyBytes)
//        let publicKey = privateKey.publicKey.rawRepresentation.toHexString()
//
//        let registerParameters = RegisterParameterV2(accessKey: appKey,
//                                                     userId: finalUserId,
//                                                     didType: didType,
//                                                     didValue: didValue,
//                                                     didSignature: signature,
//                                                     signatureRaw: signatureRaw,
//                                                     pubKeyValue: publicKey,
//                                                     pubKeyType: "ed25519",
//                                                     timestamp: timestamp,
//                                                     nickname: nil,
//                                                     avatarUrl: nil)
//
//        guard let response = try await HTTPClient.send(
//            request: RegisterRequestV2(registerParameters: registerParameters)).data else {
//            throw Web3MQNetworkingError.responseFailed(reason: .jsonEncodingFailed)
//        }
//        return response
//    }
//
//}
