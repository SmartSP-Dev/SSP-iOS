//
//  AuthAPI.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/13/25.
//

import Foundation
import Moya

enum AuthAPI {
    case loginWithApple(code: String)
}

extension AuthAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://leeyj.xyz")!
    }

    var path: String {
        switch self {
        case .loginWithApple:
            return "/auth/login/apple"
        }
    }

    var method: Moya.Method {
        switch self {
        case .loginWithApple:
            return .post
        }
    }

    var task: Task {
        switch self {
        case .loginWithApple(let code):
            return .requestJSONEncodable(["code": code])
        }
    }

    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
