//
//  NotificationQuery.swift
//  
//
//  Created by X Tommy on 2023/1/17.
//

import Foundation
import Web3MQ
import UIComponentCore

public struct NotificationQuery {
    
    /// True if the sorting in ascending order, otherwise false.
    public let isAscending: Bool
    
    ///
    public let types: [NotificationType]

    /// A pagination.
    public var pagination: Pagination
    
    public init(types: [NotificationType],
                pageSize: Int = Int.notificationPageSize,
                isAscending: Bool) {
        self.types = types
        pagination = Pagination(pageSize: pageSize)
        self.isAscending = isAscending
    }
    
}
