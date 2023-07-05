//
//  SendTopicMessageRequest.swift
//
//
//  Created by X Tommy on 2022/10/20.
//

import Foundation
import Web3MQNetworking

struct SendTopicMessageRequest: Web3MQRequest {

    typealias Response = EmptyDataResponse

    var method: HTTPMethod = .post

    var path: String = "/api/publish_topic_message/"

    var signContent: String? {
        topicId
    }

    // "topicid": topicId
    var parameters: Parameters? {
        ["topicid": topicId, "title": title, "content": content]
    }

    let topicId: String
    let title: String
    let content: String

    init(topicId: String, title: String, content: String) {
        self.topicId = topicId
        self.title = title
        self.content = content
    }

}
