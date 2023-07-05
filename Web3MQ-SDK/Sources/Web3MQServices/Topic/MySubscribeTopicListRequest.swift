//
//  MySubscribeTopicListRequest.swift
//
//
//  Created by X Tommy on 2022/11/4.
//

import Foundation
import Web3MQNetworking

struct MySubscribeTopicListRequest: Web3MQRequest {

    typealias Response = Topic

    var method: HTTPMethod = .get

    var path: String = "/api/my_subscribe_topic_list/"

    let pageCount: Int
    let pageSize: Int

}
