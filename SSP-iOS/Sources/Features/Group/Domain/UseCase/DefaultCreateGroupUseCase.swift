//
//  DefaultCreateGroupUseCase.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/29/25.
//

import Foundation

protocol CreateGroupUseCase {
    func execute(startDate: String, endDate: String, groupName: String) async throws -> GroupResponseDTO
}

final class DefaultCreateGroupUseCase: CreateGroupUseCase {
    private let repository: GroupRepository

    init(repository: GroupRepository) {
        self.repository = repository
    }

    func execute(startDate: String, endDate: String, groupName: String) async throws -> GroupResponseDTO {
        return try await repository.createGroup(startDate: startDate, endDate: endDate, groupName: groupName)
    }
}
