//
//  ContactsListViewController.swift
//  Web3MQDemo
//
//  Created by X Tommy on 2023/1/20.
//

import UIKit
import UIComponentCore
import Web3MQNetworking
import Web3MQ
import Web3MQServices

public class ContactsListViewController: UITableViewController {
    
    private lazy var listDataSource = ContactsDataSource(query: query ?? ContactsQuery(type: .followers))
    
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
    
    private(set) var query: ContactsQuery?
    
    public convenience init(query: ContactsQuery) {
        self.init()
        self.query = query
        self.title = query.type.title
    }
    
    public var errorMessageHandler: ErrorMessageHandler {
        { message in
            self.showToast(message)
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        refreshContacts()
    }
    
    @MainActor
    @objc
    private func refreshContacts() {
        Task {
            do {
                try await listDataSource.fetchFirstPage()
            } catch Web3MQNetworkingError.responseFailed(reason: .invalidHTTPStatusAPIError( _, let message)) {
                if let message {
                    errorMessageHandler(message)
                }
            }
            tableView.refreshControl?.endRefreshing()
        }
    }
    
    private func loadMore() {
        Task {
            do {
                try await listDataSource.fetchNextPage()
            } catch Web3MQNetworkingError.responseFailed(reason: .invalidHTTPStatusAPIError( _, let message)) {
                if let message {
                    errorMessageHandler(message)
                }
            }
            tableView.refreshControl?.endRefreshing()
        }
    }
    
    private lazy var dataSource = UITableViewDiffableDataSource<SingleListSection, ContactUser>(tableView: tableView) { [unowned self] tableView, indexPath, itemIdentifier in
        let cell = tableView.dequeueReusableCell(for: indexPath,
                                                 cellType: ContactsTableViewCell.self)
        cell.render(contactsUser: itemIdentifier,
                    type: self.listDataSource.query.type) {
            self.onTappedCellAccessoryButton(with: itemIdentifier)
        }
        return cell
    }
    
    private func onTappedCellAccessoryButton(with user: ContactUser) {
        
    }
    
    private func apply(contacts: [ContactUser]) {
        var snapshot = NSDiffableDataSourceSnapshot<SingleListSection, ContactUser>()
        snapshot.appendSections([.default])
        snapshot.appendItems(contacts)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: false)
            self.emptyView.isHidden = !contacts.isEmpty
        }
    }
    
}

// MARK: - TableView Delegate

extension ContactsListViewController {
    
    public override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard !listDataSource.isFetching else {
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

//MARK: - Configure Hierarchy

extension ContactsListViewController {
    
    private func configureHierarchy() {
                
        tableView.rowHeight = 56
        tableView.register(cellType: ContactsTableViewCell.self)

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshContacts),
                                 for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        emptyView.isHidden = true
        view.addSubview(emptyView)
        emptyView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
    }
    
}

extension ContactsType {
    
    var title: String {
        switch self {
        case .following: return "following"
        case .followers: return "followers"
        }
    }
    
}
