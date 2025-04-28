//
//  DefaultCreateQuizUseCase.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/27/25.
//

import Foundation

final class DefaultCreateQuizUseCase: CreateQuizUseCase {
    private let repository: QuizRepositoryProtocol
    init(repository: QuizRepositoryProtocol) {
        self.repository = repository
    }
    func execute(request: CreateQuizRequest) async throws -> Quiz {
        return try await repository.createQuiz(
            title: "사용자 입력 or 디폴트",
            keyword: request.keyword,
            type: request.type,
            fileURL: request.fileURL
        )
    }
}
