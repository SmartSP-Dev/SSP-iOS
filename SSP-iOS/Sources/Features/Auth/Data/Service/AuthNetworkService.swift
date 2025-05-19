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
    func loginWithKakao(token: String) async throws -> AuthTokenResponse
}

final class DefaultAuthNetworkService: AuthNetworkService {
    private let provider: MoyaProvider<AuthAPI>

    init(provider: MoyaProvider<AuthAPI>) {
        self.provider = provider
    }
    
    func loginWithApple(code: String) async throws -> AuthTokenResponse {
        return try await sendRequest(.loginWithApple(code: code))
    }

    func loginWithKakao(token: String) async throws -> AuthTokenResponse {
        return try await sendRequest(.loginWithKakao(token: token))
    }

    private func sendRequest(_ target: AuthAPI) async throws -> AuthTokenResponse {
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(target) { result in
                switch result {
                case .success(let response):
                    print("[Auth] 상태코드: \(response.statusCode)")
                    print("[Auth] 응답: \(String(data: response.data, encoding: .utf8) ?? "nil")")

                    guard (200..<300).contains(response.statusCode) else {
                        continuation.resume(throwing: NSError(domain: "", code: response.statusCode, userInfo: [
                            NSLocalizedDescriptionKey: "서버 응답 오류: \(response.statusCode)"
                        ]))
                        return
                    }

                    do {
                        let token = try JSONDecoder().decode(AuthTokenResponse.self, from: response.data)
                        continuation.resume(returning: token)
                    } catch {
                        continuation.resume(throwing: error)
                    }

                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
