//
//  Quiz.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/21/25.
//

import Foundation

public struct Quiz: Identifiable, Equatable {
    public let id: String
    public var title: String
    public var keyword: String
    public var type: QuizType
    public var createdAt: Date
    public var isReviewed: Bool
    public var questionCount: Int
    
    public init(
        id: String,
        title: String,
        keyword: String,
        type: QuizType,
        createdAt: Date,
        isReviewed: Bool,
        questionCount: Int
    ) {
        self.id = id
        self.title = title
        self.keyword = keyword
        self.type = type
        self.createdAt = createdAt
        self.isReviewed = isReviewed
        self.questionCount = questionCount
    }
}
