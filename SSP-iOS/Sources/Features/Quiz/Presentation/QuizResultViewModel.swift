//
//  QuizResultViewModel.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/25/25.
//

import Foundation
import Moya

final class QuizResultViewModel: ObservableObject {
    @Published var result: SubmitQuizResponse? = nil
    @Published var errorMessage: String? = nil

    private let quizId: Int
    private let provider = MoyaProvider<QuizAPI>()

    init(quizId: Int) {
        self.quizId = quizId
    }

    @MainActor
    func fetchResult() async {
        do {
            let response = try await provider.request(.quizResult(quizId: quizId))
            self.result = try response.map(SubmitQuizResponse.self)
        } catch {
            print("결과 조회 실패: \(error)")
            self.errorMessage = "채점 결과 이력이 없습니다."
        }
    }
}

