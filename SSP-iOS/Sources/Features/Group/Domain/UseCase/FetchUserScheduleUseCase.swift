//
//  FetchUserScheduleUseCase.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/30/25.
//

import Foundation

protocol FetchUserScheduleUseCase {
    func execute(groupKey: String) async throws -> [UserTimeBlockDTO]
}

final class DefaultFetchUserScheduleUseCase: FetchUserScheduleUseCase {
    private let repository: GroupRepository

    init(repository: GroupRepository) {
        self.repository = repository
    }

    func execute(groupKey: String) async throws -> [UserTimeBlockDTO] {
        return try await repository.fetchUserSchedule(groupKey: groupKey)
    }
}

