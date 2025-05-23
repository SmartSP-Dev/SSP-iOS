//
//  CreateQuizViewModel.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/27/25.
//

import Foundation
import Moya

@MainActor
final class CreateQuizViewModel: ObservableObject {
    @Published var QuizTitle: String = ""
    @Published var keyword: String = ""
    @Published var selectedType: QuizType = .multipleChoice
    @Published var fileURL: URL? = nil
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var successMessage: String?

    private let createQuizUseCase: CreateQuizUseCase
    private let uploadFileUseCase: UploadFileUseCase

    init(createQuizUseCase: CreateQuizUseCase, uploadFileUseCase: UploadFileUseCase) {
        self.createQuizUseCase = createQuizUseCase
        self.uploadFileUseCase = uploadFileUseCase
    }
    
    func uploadFile() async {
        guard let fileURL = fileURL else {
            errorMessage = "파일이 없습니다."
            return
        }

        do {
            try await uploadFileUseCase.execute(fileURL: fileURL)
            print("파일 업로드 성공")
            successMessage = "파일 업로드에 성공했습니다."
        } catch {
            print("파일 업로드 실패: \(error)")
            errorMessage = "파일 업로드에 실패했습니다."
        }
    }

    private func mimeTypeForExtension(_ ext: String) -> String {
        switch ext.lowercased() {
        case "jpg", "jpeg":
            return "image/jpeg"
        case "png":
            return "image/png"
        case "pdf":
            return "application/pdf"
        default:
            return "application/octet-stream"
        }
    }

    func generateQuiz() async {
        isLoading = true
        defer { isLoading = false }

        let request = CreateQuizRequest(
            title: QuizTitle,
            keyword: keyword,
            type: selectedType,
            fileURL: fileURL
        )

        do {
            let _ = try await createQuizUseCase.execute(request: request)
            successMessage = "퀴즈가 성공적으로 생성되었습니다."
        } catch {
            errorMessage = "퀴즈 생성 요청 실패: \(error.localizedDescription)"
        }
    }
}

extension QuizType {
    var apiValue: String {
        switch self {
        case .multipleChoice: return "MULTIPLE_CHOICE"
        case .ox: return "OX"
        case .fillInTheBlank: return "FILL_BLANK"
        }
    }
}
