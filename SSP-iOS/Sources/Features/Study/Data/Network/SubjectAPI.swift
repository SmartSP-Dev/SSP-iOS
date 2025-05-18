//
//  SubjectAPI.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/14/25.
//

import Foundation
import Moya

enum SubjectAPI {
    case create(subject: String)
    case fetchSubjects(range: String = "all")
    case delete(id: Int)
    case uploadRecord(StudyRecordRequestDTO)
    case fetchMonthlyStats

}

extension SubjectAPI: TargetType {
    var baseURL: URL { URL(string: "https://leeyj.xyz")! }

    var path: String {
        switch self {
        case .create:
            return "/study"
        case .fetchSubjects:
            return "/study/subjects"
        case .delete(let id):
            return "/study/\(id)"
        case .uploadRecord:
            return "/study/records"
        case .fetchMonthlyStats: return "/study/stats/monthly"
        }
    }

    var method: Moya.Method {
        switch self {
        case .create: return .post
        case .fetchSubjects: return .get
        case .delete: return .delete
        case .uploadRecord: return .post
        case .fetchMonthlyStats: return .get

        }
    }

    var task: Task {
        switch self {
        case .create(let subject):
            return .requestParameters(
                parameters: ["subject": subject],
                encoding: JSONEncoding.default
            )
        case .fetchSubjects(let range):
            return .requestParameters(parameters: ["range": range], encoding: URLEncoding.queryString)
        case .delete:
            return .requestPlain
        case .uploadRecord(let dto):
            return .requestJSONEncodable(dto)
        case .fetchMonthlyStats: return .requestPlain
            
        }
    }

    var headers: [String : String]? {
        var headers = ["Content-Type": "application/json"]
        if let token = KeychainManager.shared.accessToken, !token.isEmpty {
            headers["Authorization"] = "Bearer \(token)"
        }
        return headers
    }
}

