//
//  QuizMainViewModel.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/21/25.
//

import Foundation
import Combine

@MainActor
final class QuizMainViewModel: ObservableObject {
    
    // MARK: - State
    @Published var allQuizzes: [Quiz] = []
    @Published var reviewQuizzes: [Quiz] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    // MARK: - UseCases
    private let fetchAllQuizzesUseCase: FetchAllQuizzesUseCase
    private let fetchReviewTargetUseCase: FetchReviewTargetQuizzesUseCase

    // MARK: - Init
    init(
        fetchAllQuizzesUseCase: FetchAllQuizzesUseCase,
        fetchReviewTargetUseCase: FetchReviewTargetQuizzesUseCase
    ) {
        self.fetchAllQuizzesUseCase = fetchAllQuizzesUseCase
        self.fetchReviewTargetUseCase = fetchReviewTargetUseCase
    }

    // MARK: - Functions

    func fetchAll() async {
        isLoading = true
        do {
            let quizzes = try await fetchAllQuizzesUseCase.execute()
            self.allQuizzes = quizzes
        } catch {
            self.errorMessage = "전체 퀴즈를 불러오는데 실패했어요."
        }
        isLoading = false
    }

    func fetchReviewTarget() async {
        isLoading = true
        do {
            let quizzes = try await fetchReviewTargetUseCase.execute()
            self.reviewQuizzes = quizzes
        } catch {
            self.errorMessage = "복습 퀴즈를 불러오는데 실패했어요."
        }
        isLoading = false
    }
}
