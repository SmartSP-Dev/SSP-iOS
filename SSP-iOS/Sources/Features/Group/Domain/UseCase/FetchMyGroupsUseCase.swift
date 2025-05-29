//
//  FetchMyGroupsUseCase.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/29/25.
//

import Foundation

protocol FetchMyGroupsUseCase {
    func execute() async throws -> [GroupResponseDTO]
}

final class DefaultFetchMyGroupsUseCase: FetchMyGroupsUseCase {
    private let repository: GroupRepository

    init(repository: GroupRepository) {
        self.repository = repository
    }

    func execute() async throws -> [GroupResponseDTO] {
        return try await repository.fetchMyGroups()
    }
}
