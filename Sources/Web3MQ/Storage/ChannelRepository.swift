//
//  ChannelRepository.swift
//
//
//  Created by X Tommy on 2022/11/23.
//

import CoreData
import Foundation
import Web3MQServices

enum ChannelRepository {

    static func saveChannel(_ channel: Channel, context: NSManagedObjectContext) -> ChannelItem? {
        let dto = ChannelDTO.loadOrCreate(topicId: channel.topicId, context: context)
        dto.name = channel.sessionName
        dto.avatarURL = URL(string: channel.avatarUrl ?? "")
        dto.type = channel.channelType.rawValue
        context.saveIfNeeded()
        return try? dto.asModel()
    }

    static func saveChannels(_ channels: [Channel], context: NSManagedObjectContext)
        -> [ChannelItem]
    {
        channels.compactMap { saveChannel($0, context: context) }
    }

    static func fetchAllChannel(context: NSManagedObjectContext) -> [ChannelItem] {
        let request = ChannelDTO.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \ChannelDTO.updatedAt, ascending: false)
        ]
        let channels = (try? context.fetch(request)) ?? []
        return channels.compactMap { try? $0.asModel() }
    }

    static func fetchChannel(topicId: String, context: NSManagedObjectContext) -> ChannelItem? {
        return try? ChannelDTO.load(topicId: topicId, context: context)?.asModel()
    }

    static func deleteChannel(topicId: String, context: NSManagedObjectContext) {
        guard let dto = ChannelDTO.load(topicId: topicId, context: context) else {
            return
        }
        context.delete(dto)
        MessageRepository.deleteAllMessages(topicId: topicId, context: context)
    }
}
