//
//  AuthInterceptor.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/16/25.
//

import Foundation
import Alamofire
import Moya

final class AuthInterceptor: RequestInterceptor, @unchecked Sendable {
    private let keychain = KeychainManager.shared
    private let sessionRepository: SessionRepository // 리프레시 요청용

    init(sessionRepository: SessionRepository) {
        self.sessionRepository = sessionRepository
    }

    // accessToken 자동 삽입
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var request = urlRequest
        if let token = keychain.accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        completion(.success(request))
    }

    // accessToken 만료 시 자동 재발급
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard request.retryCount == 0,
              let response = request.task?.response as? HTTPURLResponse,
              response.statusCode == 401 else {
            return completion(.doNotRetry)
        }

        print("[Interceptor] 401 Unauthorized 발생 → refreshToken으로 accessToken 재발급 시도")

        guard let refreshToken = keychain.refreshToken else {
            print("[Interceptor] refreshToken 없음 → 재발급 불가")
            return completion(.doNotRetry)
        }

        sessionRepository.refreshAccessToken(refreshToken: refreshToken) { result in
            switch result {
            case .success(let newToken):
                self.keychain.saveAccessToken(newToken)
                print("[Interceptor] accessToken 재발급 성공 → 원래 요청 재시도")
                completion(.retry)

            case .failure(let error):
                print("[Interceptor] refreshToken 재발급 실패: \(error.localizedDescription)")
                self.keychain.deleteTokens()
                completion(.doNotRetry)
            }
        }
    }

}

