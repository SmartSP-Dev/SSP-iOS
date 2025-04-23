//
//  QuizRepositoryImpl.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/22/25.
//

import Foundation

final class QuizRepositoryImpl: QuizRepositoryProtocol {
    // 예시: 임시 로컬 데이터로 대응
    func fetchAllQuizzes() async throws -> [Quiz] {
        return [
            Quiz(id: "1", title: "운영체제 퀴즈", keyword: "CPU", type: .multipleChoice, createdAt: Date(), isReviewed: false, questionCount: 5),
            Quiz(id: "2", title: "데이터베이스 퀴즈", keyword: "트랜잭션", type: .ox, createdAt: Date(), isReviewed: true, questionCount: 3)
        ]
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
