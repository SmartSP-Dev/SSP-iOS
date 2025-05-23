//
//  DefaultDeleteQuizUseCase.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/23/25.
//

import Foundation

final class DefaultDeleteQuizUseCase: DeleteQuizUseCase {
    private let repository: QuizRepositoryProtocol

    init(repository: QuizRepositoryProtocol) {
        self.repository = repository
    }

    func execute(id: Int) async throws {
        try await repository.deleteQuiz(id: id)
    }
}
