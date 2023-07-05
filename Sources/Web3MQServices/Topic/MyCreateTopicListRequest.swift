//
//  MyCreateTopicListRequest.swift
//
//
//  Created by X Tommy on 2022/11/4.
//

import Foundation
import Web3MQNetworking

/// get the topics that was create by myself
struct MyCreateTopicListRequest: Web3MQRequest {

    typealias Response = Topic

    var method: HTTPMethod = .get

    var path: String = "/api/my_create_topic_list/"

    let pageCount: Int
    let pageSize: Int

    var parameters: Parameters? {
        ["page": pageCount, "size": pageSize]
    }

}
