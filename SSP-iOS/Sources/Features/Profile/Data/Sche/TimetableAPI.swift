//
//  TimetableAPI.swift
//  SSP-iOS
//
//  Created by 황상환 on 2025/05/27.
//

import Foundation
import Moya

enum TimetableAPI {
    case registerTimetable(link: String)
    case fetchMyTimetable
}

extension TimetableAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://leeyj.xyz")!
    }

    var path: String {
        switch self {
        case .registerTimetable:
            return "/calendar/timetable"
        case .fetchMyTimetable:
            return "/calendar/timetable/my"
        }
    }

    var method: Moya.Method {
        switch self {
//        case .registerTimetable:
//            return .post
        case .fetchMyTimetable, .registerTimetable:
            return .get
        }
    }

    var task: Task {
        switch self {
        case .registerTimetable(let link):
            return .requestParameters(parameters: ["url": link], encoding: URLEncoding.default) 
        case .fetchMyTimetable:
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        var headers = ["Content-Type": "application/json"]
        if let token = KeychainManager.shared.accessToken, !token.isEmpty {
            headers["Authorization"] = "Bearer \(token)"
        }
        return headers
    }
}
