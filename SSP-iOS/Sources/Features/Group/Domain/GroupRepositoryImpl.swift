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


}
