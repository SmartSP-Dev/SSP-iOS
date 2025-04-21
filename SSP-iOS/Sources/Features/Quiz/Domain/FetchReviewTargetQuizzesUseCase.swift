//
//  FetchReviewTargetQuizzesUseCase.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/21/25.
//

import Foundation

public protocol FetchReviewTargetQuizzesUseCase {
    func execute() async throws -> [Quiz]
}

public final class DefaultFetchReviewTargetQuizzesUseCase: FetchReviewTargetQuizzesUseCase {
    private let repository: QuizRepositoryProtocol

    public init(repository: QuizRepositoryProtocol) {
        self.repository = repository
    }

    public func execute() async throws -> [Quiz] {
        return try await repository.fetchReviewTargetQuizzes()
    }
}
