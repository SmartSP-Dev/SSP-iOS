//
//  DefaultFetchQuizDetailUseCase.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/23/25.
//

import Foundation

final class DefaultFetchQuizDetailUseCase: FetchQuizDetailUseCase {
    private let repository: QuizRepositoryProtocol

    init(repository: QuizRepositoryProtocol) {
        self.repository = repository
    }

    func execute(quizId: Int) async throws -> [QuizQuestion] {
        return try await repository.fetchQuizDetail(id: quizId)
    }
}
