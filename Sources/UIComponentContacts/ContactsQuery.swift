//
//  ContactsQuery.swift
//  Web3MQDemo
//
//  Created by X Tommy on 2023/1/20.
//

import Foundation
import UIComponentCore

///
public enum ContactsType {
    case followers
    case following
}

public struct ContactsQuery {

    ///
    public let type: ContactsType

    /// A pagination.
    public var pagination: Pagination

    public init(
        type: ContactsType,
        pageSize: Int = Int.chatsPageSize
    ) {
        self.type = type
        pagination = Pagination(pageSize: pageSize)
    }

}
