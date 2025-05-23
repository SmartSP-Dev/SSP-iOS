//
//  DefaultFetchQuizWeekSummaryUseCase.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/23/25.
//

import Foundation

final class DefaultFetchQuizWeekSummaryUseCase: FetchQuizWeekSummaryUseCase {
    private let repository: QuizRepositoryProtocol

    init(repository: QuizRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> FetchWeekQuizResponse {
        try await repository.fetchWeeklySummary()
    }
}
