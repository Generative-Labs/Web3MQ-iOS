//
//  SubscribeTopicRequest.swift
//
//
//  Created by X Tommy on 2022/10/20.
//

import Foundation
import Web3MQNetworking

struct SubscribeTopicRequest: Web3MQRequest {

    typealias Response = EmptyDataResponse

    var method: HTTPMethod = .post

    var path: String = "/api/subscribe_topic/"

    var signContent: String? {
        topicId
    }

    // "topicid": topicId
    var parameters: Parameters? {
        return ["topicid": topicId]
    }

    let topicId: String

    init(topicId: String) {
        self.topicId = topicId
    }

}
