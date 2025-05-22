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
    @Published var result: SubmitQuizResponse? = nil // 추가


    let quizId: Int
    private let provider = MoyaProvider<QuizAPI>()

    init(quizId: Int) {
        self.quizId = quizId
    }

    var currentQuestion: QuizQuestion {
        quizzes[currentIndex]
    }

    @MainActor
    func loadQuizDetail() async {
        do {
            let response = try await provider.request(.quizDetail(quizId: quizId))
            let decoded = try response.map([QuizQuestion].self)
            self.quizzes = decoded
        } catch {
            print("❌ 문제 불러오기 실패: \(error)")
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
    
    func deleteQuiz(completion: @escaping (Bool) -> Void) {
        guard quizId > 0 else {
            completion(false)
            return
        }

        provider.request(.quizDelete(quizId: quizId)) { result in
            switch result {
            case .success:
                print("퀴즈 삭제 성공")
                completion(true)
            case .failure(let error):
                print("퀴즈 삭제 실패: \(error)")
                completion(false)
            }
        }
    }

}
