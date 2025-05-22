//
//  QuizRepositoryImpl.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/22/25.
//

import Foundation
import Moya

final class QuizRepositoryImpl: QuizRepositoryProtocol {

    func fetchAllQuizzes() async throws -> [Quiz] {
        let provider = MoyaProvider<QuizAPI>()
        let response = try await provider.request(.quizList)
        let dtoList = try response.map([FetchQuizListResponse].self)
        return dtoList.map { $0.toDomain() }
    }

    func fetchReviewTargetQuizzes() async throws -> [Quiz] {
        return try await fetchAllQuizzes().filter { !$0.isReviewed }
    }

    func createQuiz(title: String, keyword: String, type: QuizType, fileURL: URL?) async throws -> Quiz {
        return Quiz(id: UUID().uuidString, title: title, keyword: keyword, type: type, createdAt: Date(), isReviewed: false, questionCount: 4)
    }

    func markQuizAsReviewed(id: String) async throws {
        // TODO: 실제 데이터 처리 로직
    }

    func deleteQuiz(id: String) async throws {
        // TODO: 삭제 처리
    }
}
