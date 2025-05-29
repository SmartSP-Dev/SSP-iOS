//
//  DefaultJoinGroupUseCase.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/29/25.
//

import Foundation

protocol JoinGroupUseCase {
    func execute(groupKey: String) async throws -> Bool
}

final class DefaultJoinGroupUseCase: JoinGroupUseCase {
    private let repository: GroupRepository

    init(repository: GroupRepository) {
        self.repository = repository
    }

    func execute(groupKey: String) async throws -> Bool {
        return try await repository.joinGroup(groupKey: groupKey)
    }
}
