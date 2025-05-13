//
//  AuthNetworkService.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/13/25.
//

import Foundation
import Moya

protocol AuthNetworkService {
    func loginWithApple(code: String) async throws -> AuthTokenResponse
}

final class DefaultAuthNetworkService: AuthNetworkService {
    private let provider = MoyaProvider<AuthAPI>()

    func loginWithApple(code: String) async throws -> AuthTokenResponse {
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(.loginWithApple(code: code)) { result in
                switch result {
                case .success(let response):
                    // 서버에서 받은 응답 JSON 출력
                    print("[Auth] 서버 응답 상태코드: \(response.statusCode)")
                    print("[Auth] 서버 응답 body:")
                    print(String(data: response.data, encoding: .utf8) ?? "응답 디코딩 실패")

                    do {
                        let token = try JSONDecoder().decode(AuthTokenResponse.self, from: response.data)
                        continuation.resume(returning: token)
                    } catch {
                        continuation.resume(throwing: error)
                    }

                case .failure(let error):
                    print("Moya 통신 실패: \(error)")
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
