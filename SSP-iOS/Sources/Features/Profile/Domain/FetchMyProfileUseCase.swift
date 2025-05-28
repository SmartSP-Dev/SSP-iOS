//
//  FetchMyProfileUseCase.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/28/25.
//

import Foundation

protocol FetchMyProfileUseCase {
    func execute() async throws -> MemberProfileResponse
}

final class DefaultFetchMyProfileUseCase: FetchMyProfileUseCase {
    private let repository: MemberRepository

    init(repository: MemberRepository) {
        self.repository = repository
    }

    func execute() async throws -> MemberProfileResponse {
        return try await repository.fetchMyProfile()
    }
}
