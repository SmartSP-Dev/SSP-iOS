//
//  MemberAPI.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/28/25.
//

import Foundation
import Moya

enum MemberAPI {
    case fetchMyProfile
}

extension MemberAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://leeyj.xyz")!
    }
    var path: String {
        switch self {
        case .fetchMyProfile:
            return "/members/me"
        }
    }

    var method: Moya.Method {
        switch self {
        case .fetchMyProfile:
            return .get
        }
    }

    var task: Task {
        switch self {
        case .fetchMyProfile:
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

