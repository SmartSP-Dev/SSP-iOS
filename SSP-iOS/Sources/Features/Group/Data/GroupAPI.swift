//
//  GroupAPI.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/20/25.
//

import Foundation
import Moya

enum GroupAPI {
    case fileUpload(date: String)
    case quizGenerate(title: String, keyword: String, questionType: String)
    case quizList
    case quizWeekCheck
    case quizDelete(quizId: Int)
    case quizSubmit(SubmitQuizRequest)
}

extension GroupAPI: TargetType {
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
            return "/quiz/delete/\(quizId)"
        case .quizSubmit:
            return "/quiz/submit"
            
        }
    }

    var method: Moya.Method {
        switch self {
        case .quizWeekCheck, .quizList:
            return .get
        case .quizSubmit, .quizGenerate, .fileUpload:
            return .post
        case .quizDelete:
            return .patch
        }
    }

    var task: Task {
        switch self {
        case .quizWeekCheck:
            return .requestPlain
        case .quizList:
            return .requestPlain
        case .quizSubmit(let request):
            return .requestJSONEncodable(request)
        case .generateQuiz(let title, let keyword, let questionType):
           return .requestParameters(
               parameters: [
                   "title": title,
                   "keyword": keyword,
                   "questionType": questionType
               ],
               encoding: URLEncoding.queryString
           )
        }
    }

    var headers: [String : String]? {
        var headers = ["Content-Type": "application/json"]
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

