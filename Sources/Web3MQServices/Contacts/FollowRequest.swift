//
//  File.swift
//
//
//  Created by X Tommy on 2023/2/2.
//

import Foundation
import Web3MQNetworking

public enum FollowAction: String {
    case follow
    case unfollow = "cancel"
}

///
struct FollowRequest: Web3MQRequest {

    typealias Response = EmptyDataResponse

    var method: HTTPMethod = .post

    var path: String = "/api/following/"

    /// follow or unfollow
    let action: FollowAction

    let userId: String

    let targetUserId: String

    let didType: String

    let didSignature: String

    /// starkNet PubKey (if did_type equal starkNet)
    let didPublicKey: String?

    ///
    let signRaw: String

    /// follow message
    let message: String?

    let timestamp: Int

    var parameters: Parameters? {
        var temp =
            [
                "action": action.rawValue,
                "target_userid": targetUserId,
                "did_type": didType,
                "did_signature": didSignature,
                "sign_content": signRaw,
                "userid": userId,
                "timestamp": timestamp,
            ] as [String: Any]
        temp["did_pubkey"] = didPublicKey
        temp["content"] = message
        return temp
    }

    init(
        action: FollowAction, userId: String, targetUserId: String, didType: String,
        didSignature: String, didPublicKey: String?, signRaw: String, message: String?,
        timestamp: Int
    ) {
        self.action = action
        self.userId = userId
        self.targetUserId = targetUserId
        self.didType = didType
        self.didSignature = didSignature
        self.didPublicKey = didPublicKey
        self.signRaw = signRaw
        self.message = message
        self.timestamp = timestamp
    }

}
