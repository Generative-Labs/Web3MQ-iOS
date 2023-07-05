//
//  GetUserInfoRequest.swift
//
//
//  Created by X Tommy on 2022/10/18.
//

import Foundation
import Web3MQNetworking

struct GetUserInfoRequest: Web3MQRequest {

    typealias Response = UserInfo

    var method: HTTPMethod = .post

    var path: String = "/api/get_user_info/"

    var parameters: [String: Any]? {
        ["did_type": didType, "did_value": didValue, "timestamp": Date().millisecondsSince1970]
    }

    let didType: String
    let didValue: String

    init(didType: String, didValue: String) {
        self.didType = didType
        self.didValue = didValue
    }

}

public struct UserInfo: Codable {
    public let didType: String
    public let didValue: String
    public let userId: String

    public let mainKey: String?

    public let publicKey: String?
    public let publicKeyType: String?
    public let walletAddress: String?
    public let walletType: String?
    public let signatureContent: String?
    public let timestamp: Int?
    public let didSignature: String?

    private enum CodingKeys: String, CodingKey {
        case didType = "did_type"
        case didValue = "did_value"
        case userId = "userid"
        case mainKey = "main_pubkey"
        case publicKey = "pubkey"
        case publicKeyType = "pubkey_type"
        case walletAddress = "wallet_address"
        case walletType = "wallet_type"
        case signatureContent = "signature_content"
        case timestamp = "timestamp"
        case didSignature = "did_signature"
    }
}
