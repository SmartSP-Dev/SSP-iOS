//
//  QuizAPI.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/21/25.
//

import Foundation
import Moya

enum QuizAPI {
    case fileUpload(fileData: Data, fileName: String, mimeType: String)
    case quizGenerate(title: String, keyword: String, questionType: String)
    case quizList
    case quizWeekCheck
    case quizDelete(quizId: Int)
    case quizSubmit(SubmitQuizRequest)
    case quizDetail(quizId: Int)
}

extension QuizAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://leeyj.xyz")!
    }

    var path: String {
        switch self {
        case .fileUpload:
            return "/files/upload"
        case .quizGenerate:
            return "/quiz/generate"
        case .quizList:
            return "/quiz/my"
        case .quizWeekCheck:
            return "/quiz/summary/week"
        case .quizDelete(let quizId):
            return "/quiz/\(quizId)"
        case .quizSubmit:
            return "/quiz/submit"
        case .quizDetail(let quizId):
            return "/quiz/\(quizId)"
        }
    }

    var method: Moya.Method {
        switch self {
        case .quizList, .quizWeekCheck, .quizDetail:
            return .get
        case .fileUpload, .quizGenerate, .quizSubmit:
            return .post
        case .quizDelete:
            return .delete
        }
    }

    var task: Task {
        switch self {
        case .fileUpload(let fileData, let fileName, let mimeType):
            let multipart = MultipartFormData(
                provider: .data(fileData),
                name: "file",
                fileName: fileName,
                mimeType: mimeType
            )
            return .uploadMultipart([multipart])

        case .quizGenerate(let title, let keyword, let questionType):
            return .requestParameters(
                parameters: [
                    "title": title,
                    "keyword": keyword,
                    "questionType": questionType
                ],
                encoding: URLEncoding.httpBody
            )

        case .quizSubmit(let request):
            return .requestJSONEncodable(request)

        case .quizList, .quizWeekCheck, .quizDetail, .quizDelete:
            return .requestPlain
        }
    }

    var headers: [String : String]? {
        var headers: [String: String] = [:]

        switch self {
        case .quizGenerate:
            headers["Content-Type"] = "application/x-www-form-urlencoded"
        case .quizSubmit:
            headers["Content-Type"] = "application/json"
        case .fileUpload:
            break
        default:
            break
        }

        if let token = KeychainManager.shared.accessToken, !token.isEmpty {
            headers["Authorization"] = "Bearer \(token)"
        }

        return headers
    }

    var validationType: ValidationType {
        return .successCodes
    }

    var sampleData: Data {
        return Data()
    }
}
