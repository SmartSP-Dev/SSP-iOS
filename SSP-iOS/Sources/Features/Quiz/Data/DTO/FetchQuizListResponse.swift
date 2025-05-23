//
//  FetchQuizListResponse.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/20/25.
//

import Foundation

struct FetchQuizListResponse: Decodable {
    let quizId: Int
    let title: String
    let keywords: String
    let questionType: String
    let createdAt: String
    let isReviewed: Bool
}

extension FetchQuizListResponse {
    func toDomain() -> Quiz {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.date(from: createdAt) ?? Date()

        return Quiz(
            id: "\(quizId)",
            title: title,
            keyword: keywords,
            type: QuizType(from: questionType),
            createdAt: date,
            isReviewed: isReviewed,
            questionCount: 0
        )
    }
}
