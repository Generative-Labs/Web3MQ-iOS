//
//  Components.swift
//
//
//  Created by X Tommy on 2023/2/23.
//

import Foundation

public struct ChatsComponents {

    public static let `default` = ChatsComponents()
    private init() {}

    public var chatCell: ChatsItemTableViewCell.Type = ChatsListTableViewCell.self

}
