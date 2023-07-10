//
//  ChatsListViewController.swift
//
//
//  Created by X Tommy on 2023/1/17.
//

import Combine
import UIComponentCore
import UIKit
import Web3MQ
import Web3MQNetworking

public protocol ChatsListViewControllerDelegate: AnyObject {

    func chatsListViewController(
        _ viewController: ChatsListViewController,
        didSelectChat chat: ChannelItem)
}

///
open class ChatsListViewController: UIViewController {

    public private(set) var query: ChatsListQuery?

    private lazy var chatsListDataSource = ChatsListDataSource(
        query: query ?? ChatsListQuery(types: ChannelType.all))

    ///
    private lazy var emptyView = EmptyView(
        image: UIImage(systemName: "ellipsis.bubble"),
        title: "Your message list is empty")

    ///
    private let tableView = UITableView()

    private lazy var dataSource = EditableTableViewDataSource(tableView: tableView) {
        tableView, indexPath, itemIdentifier in
        let cell = tableView.dequeueReusableCell(
            for: indexPath,
            cellType: ChatsListTableViewCell.self)
        cell.render(chatItem: itemIdentifier)
        return cell
    }

    public typealias ErrorMessageHandler = (String) -> Void

    public var errorMessageHandler: ErrorMessageHandler {
        { message in
            self.showToast(message)
        }
    }

    public weak var delegate: ChatsListViewControllerDelegate?

    public convenience init(query: ChatsListQuery) {
        self.init()
        self.query = query
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        configureHierarchy()
        bindEvents()
        apply(fetchChatsFromLocal())
        doTaskAfterConnects(store: &subscriptions) { [weak self] in
            self?.refreshChats()
        }
    }

    private var subscriptions: Set<AnyCancellable> = []

    private func bindEvents() {
        chatsListDataSource
            .chatsPublisher
            .dropFirst(1)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                self?.apply(result)
            }.store(in: &subscriptions)
    }

    private func apply(_ chats: [ChannelItem]) {
        var snapshot = NSDiffableDataSourceSnapshot<SingleListSection, ChannelItem>()
        snapshot.appendSections([.default])
        snapshot.appendItems(chats)
        dataSource.apply(snapshot, animatingDifferences: false)
        emptyView.isHidden = !chats.isEmpty
    }

    private func fetchChatsFromLocal() -> [ChannelItem] {
        ChatClient.default.fetchChatsFromLocal()
    }

    @objc
    @MainActor
    private func refreshChats() {
        Task {
            do {
                try await chatsListDataSource.fetchFirstPage()
            } catch Web3MQNetworkingError.responseFailed(
                reason: .invalidHTTPStatusAPIError(_, let message))
            {
                if let message {
                    errorMessageHandler(message)
                }
            }
            tableView.refreshControl?.endRefreshing()
        }
    }

    @MainActor
    private func loadMore() {
        Task {
            do {
                try await chatsListDataSource.fetchNextPage()
            } catch Web3MQNetworkingError.responseFailed(
                reason: .invalidHTTPStatusAPIError(_, let message))
            {
                if let message {
                    errorMessageHandler(message)
                }
            }
            tableView.refreshControl?.endRefreshing()
        }
    }

}

// MARK: - ChatsListViewController

extension ChatsListViewController: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let chat = dataSource.itemIdentifier(for: indexPath) {
            delegate?.chatsListViewController(self, didSelectChat: chat)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath)
        -> UITableViewCell.EditingStyle
    {
        let item = dataSource.itemIdentifier(for: indexPath)
        if item?.isEditable == true {
            return .delete
        } else {
            return .none
        }
    }

    public func tableView(
        _ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath
    ) {

        guard !chatsListDataSource.isFetching else {
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
}

extension ChatsListViewController {

    private func configureHierarchy() {

        tableView.rowHeight = 72
        tableView.delegate = self
        tableView.register(cellType: ChatsComponents.default.chatCell.self)
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        view.addSubview(emptyView)

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshChats), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

}

extension ChannelItem {

    var isEditable: Bool {
        switch self.type {
        case .user, .group:
            return true
        case .topic:
            return false
        }
    }
}
