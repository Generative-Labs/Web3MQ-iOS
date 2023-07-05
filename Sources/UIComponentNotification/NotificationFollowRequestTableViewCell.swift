//
//  NotificationFollowRequestTableViewCell.swift
//  
//
//  Created by X Tommy on 2023/1/16.
//

import UIKit
import UIComponentCore

protocol NotificationTableViewCellDelegate: AnyObject {
    
    func notificationCell(_ cell: NotificationBaseTableViewCell,
                          didSelectedFollow withNotification: Notification)
}

class NotificationFollowRequestTableViewCell: NotificationBaseTableViewCell {
    
    weak var delegate: NotificationTableViewCellDelegate?
    
    var isFollowing: Bool = false {
        didSet {
            followButton.isFollowing = isFollowing
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        bindEvents()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        bindEvents()
    }
    
    private lazy var followButton = FollowButton()
    
    override var accessoryButton: UIButton? {
        followButton
    }
    
    private func bindEvents() {
        followButton.addTarget(self,
                               action: #selector(didSelectedFollow),
                               for: .touchUpInside)
    }
    
    @objc
    private func didSelectedFollow() {
        guard let notification else {
            return
        }
        delegate?.notificationCell(self, didSelectedFollow: notification)
    }
    
}
