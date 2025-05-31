//
//  GroupRepositoryImpl.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/29/25.
//

import Foundation
import Moya

final class GroupRepositoryImpl: GroupRepository {
    private let provider: MoyaProvider<GroupAPI>

    init(provider: MoyaProvider<GroupAPI>) {
        self.provider = provider
    }

    func fetchMyGroups() async throws -> [GroupResponseDTO] {
        let response = try await provider.request(.fetchMyGroups)
        return try response.map([GroupResponseDTO].self)
    }
    
    func createGroup(startDate: String, endDate: String, groupName: String) async throws -> GroupResponseDTO {
        let response = try await provider.request(.createGroup(startDate: startDate, endDate: endDate, groupName: groupName))
        return try response.map(GroupResponseDTO.self)
    }
    
    func joinGroup(groupKey: String) async throws -> Bool {
        let response = try await provider.request(.joinGroup(groupKey: groupKey))
        
        // 임시 디버깅 출력
        let raw = try response.mapJSON()
        print("[조인 API 원본 응답]:", raw)

        // 기존 방식 유지 (정상 응답일 경우)
        let result = try response.map(GroupJoinResponseDTO.self)
        return result.successed
    }
    
    func fetchGroupMembers(groupKey: String) async throws -> [GroupMemberDTO] {
        let response = try await provider.request(.fetchGroupMembers(groupKey: groupKey))
        return try response.map([GroupMemberDTO].self)
    }

    func fetchGroupTimetable(groupKey: String) async throws -> [TimeBlockDTO] {
        let response = try await provider.request(.fetchGroupTimetable(groupKey: groupKey))
        let decoded = try response.map(TimeBlockResponseDTO.self)
        print("그룹 시간표 응답 디코딩 완료: \(decoded.timeBlocks)")
        return decoded.timeBlocks
    }
    
    func fetchUserSchedule(groupKey: String) async throws -> [UserTimeBlockDTO] {
        let response = try await provider.request(.fetchUserSchedule(groupKey: groupKey))
        return try response.map(UserTimeBlockResponseDTO.self).timeBlocks
    }

    func saveUserSchedule(groupKey: String, timeBlocks: [UserTimeBlockDTO]) async throws {
        let requestBody = timeBlocks
        print(">>> timeBlocks JSON to be sent: \(requestBody)")
        _ = try await provider.request(.saveUserSchedule(groupKey: groupKey, timeBlocks: requestBody))
    }

    func fetchWeightAndMembers(groupKey: String, dayOfWeek: String, time: String) async throws -> (weight: Int, members: [String]) {
           let response = try await provider.request(.getWeightAndMembers(groupKey: groupKey, dayOfWeek: dayOfWeek, time: time))
           let decoded = try JSONDecoder().decode(WeightAndMembersResponse.self, from: response.data)
           return (decoded.weight, decoded.members)
       }
}
