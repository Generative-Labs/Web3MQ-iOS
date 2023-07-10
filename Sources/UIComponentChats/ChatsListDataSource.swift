//
//  ChatsListDataSource.swift
//
//
//  Created by X Tommy on 2023/1/17.
//

import Combine
import Foundation
import UIComponentCore
import Web3MQ

class ChatsListDataSource {

    var query: ChatsListQuery

    var isFetching: Bool = false

    var chatsPublisher: AnyPublisher<[ChannelItem], Never> {
        chatsSubject.eraseToAnyPublisher()
    }

    private let chatsSubject = CurrentValueSubject<[ChannelItem], Never>([])

    init(query: ChatsListQuery) {
        self.query = query
        receiveChatsUpdateFromClient()
    }

    @discardableResult
    func fetchNextPage() async throws -> [ChannelItem] {
        query.pagination.page += 1
        let fetchedItems = try await fetchPage(pageCount: query.pagination.page)
        appendChats(fetchedItems)
        return fetchedItems
    }

    @discardableResult
    func fetchFirstPage() async throws -> [ChannelItem] {
        query.pagination.page = 1
        let items = try await fetchPage(pageCount: query.pagination.page)
        onChatsListChanged(chats: items)
        return items
    }

    private func fetchPage(pageCount: Int) async throws -> [ChannelItem] {
        guard !query.types.isEmpty else {
            return []
        }
        isFetching = true

        _ = try await ChatClient.default.chats(
            pageCount: query.pagination.page,
            pageSize: query.pagination.pageSize)
        let chats = ChatClient.default.fetchChatsFromLocal()
        isFetching = false
        return chats
    }

    private func onChatsListChanged(chats: [ChannelItem]) {
        let uniqued = chats.removingDuplicates()
        chatsSubject.send(uniqued)
    }

    private func appendChats(_ chats: [ChannelItem]) {
        var currentItems = chatsSubject.value
        currentItems.append(contentsOf: chats)
        onChatsListChanged(chats: currentItems)
    }

    private var subscriptions: Set<AnyCancellable> = []

    private func receiveChatsUpdateFromClient() {
        ChatClient.default.channelsSubject
            .sink { [weak self] chats in
                self?.onChatsListChanged(chats: chats)
            }.store(in: &subscriptions)
    }

}
