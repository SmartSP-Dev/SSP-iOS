//
//  QuizSolveViewModel.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/29/25.
//

import Foundation
import Moya

final class QuizSolveViewModel: ObservableObject {
    @Published var currentIndex = 0
    @Published var quizzes: [QuizQuestion] = []
    @Published var selectedAnswer: String? = nil
    @Published var userAnswers: [Int: String] = [:]
    @Published var isFinished = false
    @Published var result: SubmitQuizResponse? = nil

    private let deleteQuizUseCase: DeleteQuizUseCase
    private let fetchQuizDetailUseCase: FetchQuizDetailUseCase
    
    let quizId: Int
    private let provider = MoyaProvider<QuizAPI>()

    init(
        quizId: Int,
        deleteQuizUseCase: DeleteQuizUseCase,
        fetchQuizDetailUseCase: FetchQuizDetailUseCase
    ) {
        self.quizId = quizId
        self.deleteQuizUseCase = deleteQuizUseCase
        self.fetchQuizDetailUseCase = fetchQuizDetailUseCase
    }


    var currentQuestion: QuizQuestion {
        quizzes[currentIndex]
    }

    @MainActor
    func loadQuizDetail() async {
        do {
            self.quizzes = try await fetchQuizDetailUseCase.execute(quizId: quizId)
        } catch {
            print("문제 불러오기 실패: \(error)")
            self.quizzes = []
        }
    }

    func submitAnswer() {
        guard let answer = selectedAnswer else { return }
        userAnswers[currentQuestion.quizNumber] = answer
    }

    func nextQuestion() {
        submitAnswer()
        if currentIndex + 1 >= quizzes.count {
            isFinished = true
        } else {
            currentIndex += 1
            selectedAnswer = nil
        }
    }

    func submitQuiz() async {
        let answers = userAnswers.map {
            SubmitQuizRequest.Answer(quizNumber: $0.key, userAnswer: $0.value)
        }

        let body = SubmitQuizRequest(quizId: quizId, answers: answers)

        do {
            let response = try await provider.request(.quizSubmit(body))
            self.result = try response.map(SubmitQuizResponse.self)
            self.isFinished = true
            print("퀴즈 제출 성공")
        } catch {
            print("퀴즈 제출 실패: \(error)")
        }
    }
    
    func deleteQuiz() async -> Bool {
        guard quizId > 0 else {
            print("잘못된 quizId: \(quizId)")
            return false }

        do {
            try await deleteQuizUseCase.execute(id: quizId)
            print("퀴즈 삭제 성공")
            return true
        } catch {
            print("퀴즈 삭제 실패: \(error)")
            return false
        }
    }
}
