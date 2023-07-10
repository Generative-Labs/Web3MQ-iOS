//
//  NotificationFetcher.swift
//
//
//  Created by X Tommy on 2023/1/17.
//

import Combine
import Foundation
import Web3MQ

class NotificationDataStore {

    var query: NotificationQuery

    var isFetching: Bool = false

    var notificationPublisher: AnyPublisher<[Notification], Never> {
        notificationsSubject.eraseToAnyPublisher()
    }

    let notificationsSubject = CurrentValueSubject<[Notification], Never>([])

    init(query: NotificationQuery) {
        self.query = query
        receiveNotificationsFromClient()
    }

    func updateFollowingState(for id: String, isFollowing: Bool) {
        let updated = notificationsSubject.value.map { notification in
            guard notification.id == id else {
                return notification
            }
            var temp = notification
            temp.following = isFollowing
            return temp
        }
        onNotificationListChanged(notifications: updated)
    }

    @discardableResult
    func fetchNextPage() async throws -> [Notification] {
        query.pagination.page += 1
        let fetchedItems = try await fetchPage(pageCount: query.pagination.page)
        appendNotifications(fetchedItems)
        return fetchedItems
    }

    @discardableResult
    func fetchFirstPage() async throws -> [Notification] {
        query.pagination.page = 1
        let items = try await fetchPage(pageCount: query.pagination.page)
        onNotificationListChanged(notifications: items)
        return items
    }

    private func fetchPage(pageCount: Int) async throws -> [Notification] {
        guard !query.types.isEmpty else {
            return []
        }
        isFetching = true

        let response = try await ChatClient.default
            .queryNotifications(
                types: query.types,
                pageCount: query.pagination.page,
                pageSize: query.pagination.pageSize)
        isFetching = false
        return response.result.map { Notification(searchNotification: $0) }
    }

    private func onNotificationListChanged(notifications: [Notification]) {
        // removes duplicates and sorts
        let sorted = notifications.removingDuplicates().sorted { $0.timestamp > $1.timestamp }
        notificationsSubject.send(sorted)
    }

    private func appendNotifications(_ notification: [Notification]) {
        var currentItems = notificationsSubject.value
        currentItems.append(contentsOf: notification)
        onNotificationListChanged(notifications: currentItems)
    }

    private var subscriptions: Set<AnyCancellable> = []

    private func receiveNotificationsFromClient() {
        ChatClient.default
            .notificationPublisher
            .sink(receiveValue: { [weak self] messages in
                self?.appendNotifications(messages.map({ Notification(notificationMessage: $0) }))
            })
            .store(in: &subscriptions)
    }

}
