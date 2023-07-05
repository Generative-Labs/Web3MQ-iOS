//
//  Pagination.swift
//  
//
//  Created by X Tommy on 2023/1/17.
//

import Foundation

public extension Int {
    
    /// A default notification page size.
    static let notificationPageSize = 20

    /// A default chats page size.
    static let chatsPageSize = 20
    
    /// A default contacts page size
    static let contactsPageSize = 20
    
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
