//
//  ContactsDataSourceSnapshot.swift
//  Web3MQDemo
//
//  Created by X Tommy on 2022/11/10.
//

import Combine
import UIComponentCore
import UIKit
import Web3MQ
import Web3MQServices

public class ContactsDataSource {

    var query: ContactsQuery

    var isFetching: Bool = false

    var contactsPublisher: AnyPublisher<[FollowUser], Never> {
        contactsSubject.eraseToAnyPublisher()
    }

    private let contactsSubject = CurrentValueSubject<[FollowUser], Never>([])

    init(query: ContactsQuery) {
        self.query = query
    }

    @discardableResult
    func fetchNextPage() async throws -> [FollowUser] {
        query.pagination.page += 1
        let fetchedItems = try await fetchPage(pageCount: query.pagination.page)
        appendContacts(fetchedItems)
        return fetchedItems
    }

    @discardableResult
    func fetchFirstPage() async throws -> [FollowUser] {
        query.pagination.page = 1
        let items = try await fetchPage(pageCount: query.pagination.page)
        onContactsListChanged(contacts: items)
        return items
    }

    private func fetchPage(pageCount: Int) async throws -> [FollowUser] {
        isFetching = true
        let contacts: [FollowUser]
        switch query.type {
        case .followers:
            contacts = try await ChatClient.default.followersList(
                pageCount: query.pagination.page, pageSize: query.pagination.pageSize
            ).result
        case .following:
            contacts = try await ChatClient.default.followingList(
                pageCount: query.pagination.page, pageSize: query.pagination.pageSize
            ).result
        }
        isFetching = false
        return contacts
    }

    private func onContactsListChanged(contacts: [FollowUser]) {
        let uniqued = contacts.removingDuplicates()
        contactsSubject.send(uniqued)
    }

    private func appendContacts(_ contacts: [FollowUser]) {
        var currentItems = contactsSubject.value
        currentItems.append(contentsOf: contacts)
        onContactsListChanged(contacts: currentItems)
    }

}
