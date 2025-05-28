//
//  UpdateProfileUseCase.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/28/25.
//

import Foundation

protocol UpdateProfileUseCase {
    func execute(name: String, university: String, department: String) async throws -> MemberProfileResponse
}

final class DefaultUpdateProfileUseCase: UpdateProfileUseCase {
    private let repository: MemberRepository

    init(repository: MemberRepository) {
        self.repository = repository
    }

    func execute(name: String, university: String, department: String) async throws -> MemberProfileResponse {
        return try await repository.updateProfile(name: name, university: university, department: department)
    }
}
