//
//  DefaultFetchGroupTimetableUseCase.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/30/25.
//

import Foundation

final class DefaultFetchGroupTimetableUseCase: FetchGroupTimetableUseCase {
    private let repository: GroupRepository

    init(repository: GroupRepository) {
        self.repository = repository
    }

    func execute(groupKey: String) async throws -> [TimeBlockDTO] {
        return try await repository.fetchGroupTimetable(groupKey: groupKey)
    }
}
