//
//  QuizRepositoryProtocol.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/21/25.
//

import Foundation

public protocol QuizRepositoryProtocol {
    // 전체 퀴즈 목록 가져오기
    func fetchAllQuizzes() async throws -> [Quiz]

    // 복습이 필요한 퀴즈만 가져오기 (ex: 이번 주 & isReviewed == false)
    func fetchReviewTargetQuizzes() async throws -> [Quiz]

    // 퀴즈 생성 (GPT/OCR 등 처리 포함)
    func createQuiz(title: String, keyword: String, type: QuizType, fileURL: URL?) async throws -> Quiz

    // 퀴즈 복습 완료 처리
    func markQuizAsReviewed(id: String) async throws

    // 퀴즈 삭제
    func deleteQuiz(id: String) async throws
}
