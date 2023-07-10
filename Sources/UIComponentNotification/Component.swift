//
//  NotificationComponents.swift
//
//
//  Created by X Tommy on 2023/2/23.
//

import UIComponentCore
import UIKit
import Web3MQ

public class NotificationComponents {

    public static var `default` = NotificationComponents()
    private init() {}

    weak var requestHander: NotificationTableViewCellDelegate?

    public lazy var cellRender: (UITableView, IndexPath, Notification) -> UITableViewCell = {
        [weak self] tableView, indexPath, notification in
        guard let type = NotificationType(rawValue: notification.type ?? "") else {
            return UITableViewCell()
        }
        switch type {
        case .receivedFriendRequest:
            let cell = tableView.dequeueReusableCell(
                for: indexPath,
                cellType: NotificationFollowRequestTableViewCell.self)
            cell.render(notification: notification)
            cell.delegate = self?.requestHander
            cell.isFollowing = notification.following
            return cell
        case .subscription, .provider, .sendFriendRequest, .groupInvitation:
            let cell = tableView.dequeueReusableCell(
                for: indexPath,
                cellType: NotificationTextTableViewCell.self)
            cell.render(notification: notification)
            return cell
        }
    }

}
