//
//  Pagination.swift
//
//
//  Created by X Tommy on 2023/1/17.
//

import Foundation

extension Int {

    /// A default notification page size.
    public static let notificationPageSize = 20

    /// A default chats page size.
    public static let chatsPageSize = 20

    /// A default contacts page size
    public static let contactsPageSize = 20

}

/// Basic pagination with `pageSize` and `page`.
public struct Pagination {

    /// A page count
    public var page: Int

    /// A page size.
    public var pageSize: Int

    public init(page: Int = 1, pageSize: Int) {
        self.page = page
        self.pageSize = pageSize
    }

}
