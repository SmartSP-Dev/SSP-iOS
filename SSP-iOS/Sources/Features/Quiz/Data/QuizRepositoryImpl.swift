//
//  QuizRepositoryImpl.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/22/25.
//

import Foundation
import Moya

final class QuizRepositoryImpl: QuizRepositoryProtocol {

    func fetchAllQuizzes() async throws -> [Quiz] {
        let provider = MoyaProvider<QuizAPI>()
        let response = try await provider.request(.quizList)
        let dtoList = try response.map([FetchQuizListResponse].self)
        return dtoList.map { $0.toDomain() }
    }

    func fetchReviewTargetQuizzes() async throws -> [Quiz] {
        return try await fetchAllQuizzes().filter { !$0.isReviewed }
    }
    
    func fetchWeeklySummary() async throws -> FetchWeekQuizResponse {
        let provider = MoyaProvider<QuizAPI>()
        let response = try await provider.request(.quizWeekCheck)
        return try response.map(FetchWeekQuizResponse.self)
    }

    func createQuiz(title: String, keyword: String, type: QuizType, fileURL: URL?) async throws -> Quiz {
        let provider = MoyaProvider<QuizAPI>()
        let response = try await provider.request(.quizGenerate(
            title: title,
            keyword: keyword,
            questionType: type.apiValue
        ))

        // 서버 응답 로그 출력
        print("응답 상태 코드: \(response.statusCode)")
        print("응답 본문:\n" + (String(data: response.data, encoding: .utf8) ?? "디코딩 실패"))

        let decoded = try response.map(QuizGenerateResponse.self)

        return Quiz(
            id: UUID().uuidString,
            title: title,
            keyword: keyword,
            type: type,
            createdAt: Date(),
            isReviewed: false,
            questionCount: decoded.quizzes.count
        )
    }


    func markQuizAsReviewed(id: String) async throws {
        // TODO: 실제 데이터 처리 로직
    }

    func deleteQuiz(id: Int) async throws {
        let provider = MoyaProvider<QuizAPI>()
        let target = QuizAPI.quizDelete(quizId: id)

        let fullURL = "\(target.baseURL)\(target.path)"
        print("[DELETE QUIZ] 요청 URL: \(fullURL)")

        _ = try await provider.request(target)
    }
    
    func uploadFile(fileURL: URL) async throws {
        let fileData = try Data(contentsOf: fileURL)
        let fileName = fileURL.lastPathComponent
        let mimeType = mimeTypeForExtension(fileURL.pathExtension)

        let provider = MoyaProvider<QuizAPI>()
        _ = try await provider.request(.fileUpload(
            fileData: fileData,
            fileName: fileName,
            mimeType: mimeType
        ))
    }

    // 내부 메서드로 추가
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
    
    func fetchQuizDetail(id: Int) async throws -> [QuizQuestion] {
        let provider = MoyaProvider<QuizAPI>()
        let response = try await provider.request(.quizDetail(quizId: id))
        return try response.map([QuizQuestion].self)
    }

}
