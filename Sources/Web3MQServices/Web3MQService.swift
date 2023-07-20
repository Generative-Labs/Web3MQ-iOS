//
//  Web3MQService.swift
//
//
//  Created by X Tommy on 2023/3/2.
//

import CryptoKit
import Foundation
import Web3MQNetworking
@_exported import Web3MQNetworking

public protocol Service: AnyObject {

    var appKey: String? { get set }

    var client: HTTPClient { get set }

    var walletConnector: WalletConnector? { get set }

    func register(did: DID, password: String) async throws -> RegisterResult

    func fetchPrivateKey(did: DID, password: String) async throws -> Curve25519.Signing.PrivateKey

    /// Get a user with its `DID` and password, also with an duration for expired.
    func user(
        did: DID,
        password: String,
        expiredDuration: TimeInterval
    ) async throws -> ConnectionInfo

    /// Get a user with its `DID` and privateKey, also with an duration for expired.
    func user(
        did: DID,
        privateKey: Curve25519.Signing.PrivateKey,
        expiredDuration: TimeInterval
    ) async throws -> ConnectionInfo

    func searchUsers(keyword: String) async throws -> Page<UserInfo>

    func userInfo(didType: String, didValue: String) async throws -> UserInfo?

    func getOrGenerateUserId(for didType: String, didValue: String) async throws -> String

    func profile() async throws -> UserProfile

    func publicProfile(userId: String, didType: String, didValue: String) async throws
        -> UserProfile

    func userPermissions(userId: String) async throws -> PermissionResponse

    func permissions() async throws -> UserPermissions
    
    func updatePermissionSettings(permissions: UserPermissions) async throws
    
    func changeProfile(nickName: String, avatarUrl: String?) async throws -> UserProfile

    func updateNotificationStatus(_ notificationIds: [String], status: NotificationStatus)
        async throws

    func queryNotifications(types: [NotificationType], pageCount: Int, pageSize: Int) async throws
        -> Page<SearchedNotificationMessage>

    func updateMessageStatus(
        messageIds: [String], topicId: String, status: MessageReadStatus, timestamp: UInt64)
        async throws

    func messageHistory(topicId: String, pageCount: Int, pageSize: Int) async throws -> Page<
        Message
    >

    func channels(pageCount: Int, pageSize: Int) async throws -> [Channel]

    func follow(targetUserId: String, message: String?) async throws

    func unfollow(targetUserId: String) async throws

    func followingList(pageCount: Int, pageSize: Int) async throws -> Page<FollowUser>

    func followersList(pageCount: Int, pageSize: Int) async throws -> Page<FollowUser>

    func followContacts(pageCount: Int, pageSize: Int) async throws -> Page<FollowUser>

    func makeFriendRequest(to targetUserId: String, message: String) async throws

    func agreeFriendRequest(userId: String) async throws

    ///
    func groupList(pageCount: Int, pageSize: Int) async throws -> Page<Group>

    func createGroup(groupName: String, avatarUrl: String?) async throws -> Group

    func groupMemberList(groupId: String, pageCount: Int, pageSize: Int) async throws -> Page<
        ContactUser
    >

    func groupInviteUser(_ userIds: [String], join groupId: String) async throws

    func groupInfo(groupId: String) async throws -> Group?

    func createTopic(_ topicName: String?) async throws -> String

    func subscribeTopic(_ topicId: String) async throws

    func publish(toTopic topicId: String, title: String, content: String) async throws

    func myCreateTopics(pageCount: Int, pageSize: Int) async throws -> Page<Topic>

    func mySubscribeTopics(pageCount: Int, pageSize: Int) async throws -> Page<Topic>

}

///
public class Web3MQService: Service {

    public var appKey: String?

    ///
    public var client: HTTPClient

    ///
    public var walletConnector: WalletConnector?

    ///
    public init(client: HTTPClient = Web3MQHTTPClient(), walletConnector: WalletConnector? = nil) {
        self.client = client
        self.walletConnector = walletConnector
    }

}
