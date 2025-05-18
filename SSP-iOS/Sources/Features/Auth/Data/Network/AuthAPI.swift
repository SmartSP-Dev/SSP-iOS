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
    case loginWithKakao(token: String)
    case refreshToken(token: String)
}

extension AuthAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://leeyj.xyz")!
    }

    var path: String {
        switch self {
        case .loginWithApple:
            return "/auth/login/apple"
        case .loginWithKakao:
            return "/auth/login/kakao/token"
        case .refreshToken:
            return "/auth/refresh"
        }
    }

    var method: Moya.Method {
        switch self {
        case .loginWithApple, .loginWithKakao, .refreshToken:
            return .post
        }
    }

    var task: Task {
        switch self {
        case .loginWithApple(let code):
            return .requestJSONEncodable(["code": code])
        case .loginWithKakao(let token):
            return .requestJSONEncodable(["accessToken": token])
        case .refreshToken(let token):
            return .requestJSONEncodable(["accessToken": token])
        }
    }

    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
