//
//  CreateQuizViewModel.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/27/25.
//

import Foundation

@MainActor
final class CreateQuizViewModel: ObservableObject {
    @Published var keyword: String = ""
    @Published var selectedType: QuizType = .multipleChoice
    @Published var fileURL: URL? = nil
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let createQuizUseCase: CreateQuizUseCase

    init(createQuizUseCase: CreateQuizUseCase) {
        self.createQuizUseCase = createQuizUseCase
    }

    func createQuiz() async {
        isLoading = true
        do {
            let request = CreateQuizRequest(
                fileURL: fileURL,
                keyword: keyword,
                type: selectedType
            )
            _ = try await createQuizUseCase.execute(request: request)
            // 성공시 뒤로가기 or 알림
        } catch {
            errorMessage = "퀴즈 생성 실패"
        }
        isLoading = false
    }
}
