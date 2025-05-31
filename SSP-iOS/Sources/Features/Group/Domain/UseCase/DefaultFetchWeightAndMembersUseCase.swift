//
//  DefaultFetchWeightAndMembersUseCase.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/31/25.
//

import Foundation

final class DefaultFetchWeightAndMembersUseCase: FetchWeightAndMembersUseCase {
    private let repository: GroupRepository

    init(repository: GroupRepository) {
        self.repository = repository
    }

    func execute(groupKey: String, dayOfWeek: String, time: String) async throws -> (weight: Int, members: [String]) {
        print("[UseCase 요청] groupKey: \(groupKey), dayOfWeek: \(dayOfWeek), time: \(time)")
        
        let result = try await repository.fetchWeightAndMembers(
            groupKey: groupKey,
            dayOfWeek: dayOfWeek,
            time: time
        )
        
        print("[UseCase 응답] weight: \(result.weight), members: \(result.members)")
        return result
    }
}
