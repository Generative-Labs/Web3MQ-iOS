//
//  Web3MQService+Notification.swift
//
//
//  Created by X Tommy on 2023/3/2.
//

import Foundation
import Web3MQNetworking

extension Web3MQService {

    public func queryNotifications(types: [NotificationType], pageCount: Int, pageSize: Int)
        async throws
        -> Page<SearchedNotificationMessage>
    {
        try await client.send(
            request: QueryNotificationsRequest(types: types, page: pageCount, size: pageSize)
        ).page ?? Page.empty()
    }

    public func updateNotificationStatus(_ notificationIds: [String], status: NotificationStatus)
        async throws
    {
        _ = try await client.send(
            request: NotificationStatusRequest(notificationIds: notificationIds, status: status))
    }

}
