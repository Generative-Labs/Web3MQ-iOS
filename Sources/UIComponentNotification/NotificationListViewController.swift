//
//  NotificationViewController.swift
//  
//
//  Created by X Tommy on 2023/1/16.
//

import UIKit
import Combine
import Web3MQ
import UIComponentCore
import SnapKit
import Web3MQNetworking

public protocol NotificationListDelegate: AnyObject {
    
    func notificationList(didSelectedFollow userId: String) async throws
}

///
public class NotificationListViewController: UIViewController {
    
    private var subscriptions: Set<AnyCancellable> = []
    
    private lazy var notificationDataSource = NotificationDataStore(query: query ?? NotificationQuery(types: [], isAscending: true))
    
    private let tableView = UITableView()
    
    public weak var delegate: NotificationListDelegate?
    
    public var emptyViewTitle: String? {
        didSet {
            emptyView.title = emptyViewTitle
        }
    }
    
    public var emptyViewImage: UIImage? {
        didSet {
            emptyView.image = emptyViewImage
        }
    }
    
    private lazy var emptyView = EmptyView()
    
    private lazy var dataSource = UITableViewDiffableDataSource<SingleListSection, Notification>(tableView: tableView) { tableView, indexPath, itemIdentifier in
        guard let type = NotificationType(rawValue: itemIdentifier.type ?? "") else {
            return UITableViewCell()
        }
        switch type {
        case .receivedFriendRequest:
            let cell = tableView.dequeueReusableCell(for: indexPath,
                                                     cellType: NotificationFollowRequestTableViewCell.self)
            cell.render(notification: itemIdentifier)
            cell.delegate = self
            cell.isFollowing = itemIdentifier.following
            return cell
        case .subscription, .provider, .sendFriendRequest, .groupInvitation:
            let cell = tableView.dequeueReusableCell(for: indexPath,
                                                     cellType: NotificationTextTableViewCell.self)
            cell.render(notification: itemIdentifier)
            return cell
        }
    }
        
    public var errorMessageHandler: ErrorMessageHandler {
        { message in
            self.showToast(message)
        }
    }
    
    private(set) var query: NotificationQuery?
    
    public convenience init(query: NotificationQuery) {
        self.init()
        self.query = query
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        bindEvents()
    }
    
    public func updateFollowingState(messageId: String, isFollowing: Bool) {
        notificationDataSource.updateFollowingState(for: messageId, isFollowing: isFollowing)
    }
    
    private func bindEvents() {
        notificationDataSource
            .notificationPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                self?.apply(notifications: result)
            }.store(in: &subscriptions)
    }
    
    private func loadMore() {
        Task {
            do {
                try await notificationDataSource.fetchNextPage()
            } catch Web3MQNetworkingError.responseFailed(reason: .invalidHTTPStatusAPIError( _, let message)) {
                if let message {
                    errorMessageHandler(message)
                }
            }
            tableView.refreshControl?.endRefreshing()
        }
    }
    
    private func apply(notifications: [Notification]) {
        var snapshot = NSDiffableDataSourceSnapshot<SingleListSection, Notification>()
        snapshot.appendSections([.default])
        snapshot.appendItems(notifications)
        dataSource.apply(snapshot, animatingDifferences: false)
        emptyView.isHidden = !notifications.isEmpty
    }
    
}

//MARK: - NotificationTableViewCellDelegate

extension NotificationListViewController: NotificationTableViewCellDelegate {

    func notificationCell(_ cell: NotificationBaseTableViewCell,
                          didSelectedFollow withNotification: Notification) {
        guard let delegate = self.delegate else {
            return
        }
        let from = withNotification.from
        Task {
            try await delegate.notificationList(didSelectedFollow: from)
            // followed
            updateFollowingState(messageId: withNotification.id, isFollowing: true)
        }
    }
}

// MARK: - UITableViewDelegate

extension NotificationListViewController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard !notificationDataSource.isFetching else {
            return
        }
        
        guard tableView.isTrackingOrDecelerating else {
            return
        }
        
        if indexPath.row < tableView.numberOfRows(inSection: 0) - 2 {
            return
        }
        
        loadMore()
    }
    
    public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return UISwipeActionsConfiguration(actions: [UIContextualAction.init(style: .destructive, title: "Delete", handler: { _, _, _ in
            var currentSnapshot = self.dataSource.snapshot()
            if let item = self.dataSource.itemIdentifier(for: indexPath) {
                currentSnapshot.deleteItems([item])
                self.dataSource.apply(currentSnapshot)
                ChatClient.default.deleteChannel(topicId: item.topicId)
            }
        })])
    }
    
}

// MARK: - Configure Hierarchy

extension NotificationListViewController {
    
    private func configureHierarchy() {
        
        tableView.separatorStyle = .none
        tableView.rowHeight = 74
        tableView.delegate = self
        tableView.register(cellType: NotificationTextTableViewCell.self)
        tableView.register(cellType: NotificationFollowRequestTableViewCell.self)
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        emptyView.isHidden = true
        view.addSubview(emptyView)
        emptyView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
}
