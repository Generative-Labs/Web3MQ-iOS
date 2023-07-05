//
//  Web3MQService+Group.swift
//
//
//  Created by X Tommy on 2023/3/2.
//

import Foundation
import Web3MQNetworking

extension Web3MQService {

    public func groupList(pageCount: Int, pageSize: Int) async throws -> Page<Group> {
        try await client.send(
            request: GroupListRequest(
                pageCount: pageCount,
                pageSize: pageSize)
        ).page ?? Page<Group>()
    }

    public func createGroup(
        groupName: String,
        avatarUrl: String? = nil
    ) async throws -> Group {
        guard
            let group = try await client.send(
                request: CreateGroupRequest(
                    groupName: groupName,
                    avatarUrl: avatarUrl)
            ).data
        else {
            throw Web3MQNetworkingError.responseFailed(reason: .dataEmpty)
        }
        return group
    }

    public func groupMemberList(groupId: String, pageCount: Int, pageSize: Int) async throws
        -> Page<ContactUser>
    {
        try await client.send(
            request: GroupMemberListRequest(
                groupId: groupId,
                pageCount: pageCount,
                pageSize: pageSize)
        ).page ?? Page<ContactUser>()
    }

    public func groupInviteUser(_ userIds: [String], join groupId: String) async throws {
        try await client.send(
            request: GroupInviteRequest(
                groupId: groupId,
                members: userIds))
    }

    public func groupInfo(groupId: String) async throws -> Group? {
        guard
            let group = try await client.send(
                request: GroupInfoRequest(
                    groupId: groupId)
            ).data
        else {
            throw Web3MQNetworkingError.responseFailed(reason: .dataEmpty)
        }
        return group
    }

}
