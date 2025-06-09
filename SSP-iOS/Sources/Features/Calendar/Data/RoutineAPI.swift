//
//  RoutineAPI.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/19/25.
//

import Foundation
import Moya

enum RoutineAPI {
    case fetchRoutines(date: String)
    case addRoutine(title: String)
    case toggleCheck(routineId: Int, date: String, completed: Bool)
    case deleteRoutine(routineId: Int)
    case fetchSummary
}

extension RoutineAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://leeyj.xyz")!
    }

    var path: String {
        switch self {
        case .fetchRoutines:
            return "/routines"
        case .addRoutine:
            return "/routines"
        case .toggleCheck:
            return "/routines/check"
        case .deleteRoutine(let id):
            return "/routines/\(id)/delete"
        case .fetchSummary:
            return "/routines/summary"
        }
    }

    var method: Moya.Method {
        switch self {
        case .fetchRoutines, .fetchSummary:
            return .get
        case .addRoutine:
            return .post
        case .toggleCheck, .deleteRoutine:
            return .patch
        }
    }

    var task: Task {
        switch self {
        case .fetchRoutines(let date):
            return .requestParameters(parameters: ["date": date], encoding: URLEncoding.queryString)

        case .addRoutine(let title):
            return .requestJSONEncodable(["title": title])

        case .toggleCheck(let routineId, let date, let completed):
            let body = ToggleCheckRequest(routineId: routineId, date: date, completed: completed)
            return .requestJSONEncodable(body)

        case .deleteRoutine:
            return .requestPlain

        case .fetchSummary:
            return .requestPlain
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
