//
//  QuizMainViewModel.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/21/25.
//

import Foundation
import Combine
import Moya

@MainActor
final class QuizMainViewModel: ObservableObject {
    
    // MARK: - State
    @Published var allQuizzes: [Quiz] = []
    @Published var reviewQuizzes: [Quiz] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    @Published var quizWeekSummary: FetchWeekQuizResponse?

    // MARK: - UseCases
    private let fetchAllQuizzesUseCase: FetchAllQuizzesUseCase
    private let fetchReviewTargetUseCase: FetchReviewTargetQuizzesUseCase
    private let fetchQuizWeekSummaryUseCase: FetchQuizWeekSummaryUseCase

    // MARK: - Init
    init(
        fetchAllQuizzesUseCase: FetchAllQuizzesUseCase,
        fetchReviewTargetUseCase: FetchReviewTargetQuizzesUseCase,
        fetchQuizWeekSummaryUseCase: FetchQuizWeekSummaryUseCase
    ) {
        self.fetchAllQuizzesUseCase = fetchAllQuizzesUseCase
        self.fetchReviewTargetUseCase = fetchReviewTargetUseCase
        self.fetchQuizWeekSummaryUseCase = fetchQuizWeekSummaryUseCase
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
    
    func fetchQuizSummary() async {
        do {
            let summary = try await fetchQuizWeekSummaryUseCase.execute()
            self.quizWeekSummary = summary
        } catch {
            self.errorMessage = "퀴즈 요약 정보를 불러오는데 실패했어요."
        }
    }

}
