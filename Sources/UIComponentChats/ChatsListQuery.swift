//
//  ChatsListQuery.swift
//  
//
//  Created by X Tommy on 2023/1/18.
//

import Foundation
import UIComponentCore
import Web3MQ

public struct ChatsListQuery {
    
    ///
    public let types: Set<ChannelType>

    /// A pagination.
    public var pagination: Pagination
    
    public init(types: Set<ChannelType>,
                pageSize: Int = Int.contactsPageSize) {
        self.types = types
        pagination = Pagination(pageSize: pageSize)
    }
    
}
