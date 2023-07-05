//
//  Session.swift
//
//
//  Created by X Tommy on 2022/11/16.
//

import Foundation

public struct Chat: Hashable {

    let session: Channel

    var latestMessage: String?

    var badge: String?

    var avatarUrl: String?

}
