//
//  Client+API.swift
//
//
//  Created by X Tommy on 2023/2/7.
//

import CryptoKit
import CryptoSwift
import Foundation

// MARK: - User

extension ChatClient {

    /// Registers a new user with the given `DID` and password.
    public func register(did: DID, password: String) async throws -> RegisterResult {
        try await service.register(did: did, password: password)
    }

    /// Fetches the private key for the user with the given `DID` and password.
    public func fetchPrivateKey(did: DID, password: String) async throws
        -> Curve25519.Signing.PrivateKey
    {
        try await service.fetchPrivateKey(did: did, password: password)
    }

    /// Gets a `ConnectionInfo` with the given `DID` and password, as well as an expiration duration (in milliseconds).
    /// Requires `WalletConnector`.
    public func connectionInfo(
        did: DID,
        password: String,
        expiredDuration: TimeInterval = 86400 * 1000
    ) async throws -> ConnectionInfo {
        return try await service.user(
            did: did, password: password, expiredDuration: expiredDuration)
    }

    /// Gets a `ConnectionInfo` with the given `DID` and private key, as well as an expiration duration (in milliseconds).
    public func connectionInfo(
        did: DID,
        privateKey: Curve25519.Signing.PrivateKey,
        expiredDuration: TimeInterval = 86400 * 1000
    ) async throws -> ConnectionInfo {
        return try await service.user(
            did: did, privateKey: privateKey, expiredDuration: expiredDuration)
    }

    /// Searches for users with the given keyword.
    public func searchUsers(keyword: String) async throws -> Page<UserInfo> {
        try await service.searchUsers(keyword: keyword)
    }

    /// Retrieves user information for the user with the given `didType` and `didValue`.
    public func userInfo(did: DID) async throws -> UserInfo? {
        try await service.userInfo(didType: did.type, didValue: did.value)
    }

    /// Gets the user ID associated with the given `didType` and `didValue`, or generates a new one if none exists.
    public func getOrGenerateUserId(for didType: String, didValue: String) async throws -> String {
        try await service.getOrGenerateUserId(for: didType, didValue: didValue)
    }

    /// Retrieves the current user's profile information.
    public func profile() async throws -> UserProfile {
        let response = try await service.profile()
        // Save the user's profile to the local repository.
        defer {
            _ = UserRepository.saveUser(
                payload: UserPayload(
                    id: response.userId, name: response.nickname,
                    avatarURL: URL(string: response.avatarUrl ?? "")),
                context: persistentContainer.viewContext)
            persistentContainer.saveContext()
        }
        return response
    }

    /// Retrieves the public profile information for the user with the given `userId`, `didType`, and `didValue`.
    public func publicProfile(userId: String, didType: String, didValue: String) async throws
        -> UserProfile
    {
        try await service.publicProfile(userId: userId, didType: didType, didValue: didValue)
    }

    /// Retrieves the user permissions for the user with the given `userId`.
    public func userPermissions(userId: String) async throws -> PermissionResponse {
        try await service.userPermissions(userId: userId)
    }
    
    public func permissions() async throws -> UserPermissions {
        try await service.permissions()
    }
    
    public func updatePermissions(permissions: UserPermissions) async throws {
        try await service.updatePermissionSettings(permissions: permissions)
    }
    
    /// Changes the current user's profile information.
    public func changeProfile(nickName: String, avatarUrl: String?) async throws -> UserProfile {
        try await service.changeProfile(nickName: nickName, avatarUrl: avatarUrl)
    }

}

// MARK: - Notification

extension ChatClient {

    public func updateNotificationStatus(_ notificationIds: [String], status: NotificationStatus)
        async throws
    {
        try await service.updateNotificationStatus(notificationIds, status: status)
    }

    public func queryNotifications(types: [NotificationType], pageCount: Int, pageSize: Int)
        async throws -> Page<SearchedNotificationMessage>
    {
        try await service.queryNotifications(types: types, pageCount: pageCount, pageSize: pageSize)
    }

}

// MARK: - Message

extension ChatClient {

    @discardableResult
    public func sendMessage(_ text: String, to topic: String, cipherSuite: String = "NONE")
        async throws -> Web3MQMessage
    {
        guard let user = self.user,
            let keyPair = try? KeyPair(user.sessionKey)
        else {
            throw Web3MQClientError.userEmpty
        }
        return try await webSocket.sendMessage(
            content: text, topicId: topic, messageType: .chat, cipherSuite: cipherSuite,
            userId: user.userId, privateKey: keyPair.privateKey)
    }

    public func updateMessageStatus(
        messageIds: [String], topicId: String, status: MessageReadStatus, timestamp: UInt64
    ) async throws {
        defer {
            MessageRepository.updateMessagesStatus(
                messageIds: messageIds,
                status: status.rawValue,
                timestamp: timestamp,
                context: persistentContainer.writableContext)
            refreshChats()
        }
        try await service.updateMessageStatus(
            messageIds: messageIds, topicId: topicId, status: status, timestamp: timestamp)
    }

    public func messagesFromLocalCache(topicId: String) -> [Message] {
        let dtoes = MessageRepository.fetchAllMessages(
            topicId: topicId,
            context: persistentContainer.viewContext)
        return dtoes.map { $0.toMessage() }
    }

    public func messageHistory(topicId: String, pageCount: Int, pageSize: Int) async throws -> Page<
        Message
    > {
        let page = try await service.messageHistory(
            topicId: topicId, pageCount: pageCount, pageSize: pageSize)
        defer {
            MessageRepository.insertMessages(
                messages: page.result,
                context: persistentContainer.writableContext)
            refreshChats()
        }
        return page
    }

    public func chats(pageCount: Int, pageSize: Int) async throws -> [ChannelItem] {
        let channels = try await service.channels(pageCount: pageCount, pageSize: pageSize)
        return ChannelRepository.saveChannels(
            channels, context: persistentContainer.writableContext)
    }

    public func deleteChannel(topicId: String) {
        ChannelRepository.deleteChannel(
            topicId: topicId, context: persistentContainer.writableContext)
    }

    public func fetchChatsFromLocal() -> [ChannelItem] {
        ChannelRepository.fetchAllChannel(context: persistentContainer.viewContext)
    }

}

// MARK: - Contacts

extension ChatClient {

    public func follow(targetUserId: String, message: String? = nil) async throws {
        try await service.follow(targetUserId: targetUserId, message: message)
    }

    public func unfollow(targetUserId: String) async throws {
        try await service.unfollow(targetUserId: targetUserId)
    }

    public func followingList(pageCount: Int, pageSize: Int) async throws -> Page<FollowUser> {
        try await service.followingList(pageCount: pageCount, pageSize: pageSize)
    }

    public func followersList(pageCount: Int, pageSize: Int) async throws -> Page<FollowUser> {
        try await service.followersList(pageCount: pageCount, pageSize: pageSize)
    }

    public func followContacts(pageCount: Int, pageSize: Int) async throws -> Page<FollowUser> {
        try await service.followContacts(pageCount: pageCount, pageSize: pageSize)
    }

    public func makeFriendRequest(to targetUserId: String, message: String) async throws {
        try await service.makeFriendRequest(to: targetUserId, message: message)
    }

    public func agreeFriendRequest(userId: String) async throws {
        try await service.agreeFriendRequest(userId: userId)
    }

}

// MARK: - Group

extension ChatClient {

    ///
    public func groupList(pageCount: Int, pageSize: Int) async throws -> Page<Group> {
        try await service.groupList(pageCount: pageCount, pageSize: pageSize)
    }

    public func createGroup(groupName: String, avatarUrl: String?) async throws -> Group {
        try await service.createGroup(groupName: groupName, avatarUrl: avatarUrl)
    }

    public func groupMemberList(groupId: String, pageCount: Int, pageSize: Int) async throws
        -> Page<ContactUser>
    {
        try await service.groupMemberList(
            groupId: groupId, pageCount: pageCount, pageSize: pageSize)
    }

    public func groupInviteUser(_ userIds: [String], join groupId: String) async throws {
        try await service.groupInviteUser(userIds, join: groupId)
    }

    public func groupInfo(groupId: String) async throws -> Group? {
        try await service.groupInfo(groupId: groupId)
    }

}

// MARK: - Topic

extension ChatClient {

    public func createTopic(_ topicName: String?) async throws -> String {
        try await service.createTopic(topicName)
    }

    public func subscribeTopic(_ topicId: String) async throws {
        try await service.subscribeTopic(topicId)
    }

    public func publish(toTopic topicId: String, title: String, content: String) async throws {
        try await service.publish(toTopic: topicId, title: title, content: content)
    }

    public func myCreateTopics(pageCount: Int, pageSize: Int) async throws -> Page<Topic> {
        try await service.myCreateTopics(pageCount: pageCount, pageSize: pageSize)
    }

    public func mySubscribeTopics(pageCount: Int, pageSize: Int) async throws -> Page<Topic> {
        try await service.mySubscribeTopics(pageCount: pageCount, pageSize: pageSize)
    }

}
