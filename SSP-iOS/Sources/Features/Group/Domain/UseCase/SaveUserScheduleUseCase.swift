//
//  SaveUserScheduleUseCase.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/30/25.
//

import Foundation

protocol SaveUserScheduleUseCase {
    func execute(groupKey: String, blocks: [UserTimeBlockDTO]) async throws
}

final class DefaultSaveUserScheduleUseCase: SaveUserScheduleUseCase {
    private let repository: GroupRepository

    init(repository: GroupRepository) {
        self.repository = repository
    }

    func execute(groupKey: String, blocks: [UserTimeBlockDTO]) async throws {
        try await repository.saveUserSchedule(groupKey: groupKey, timeBlocks: blocks)
    }
}
