//
//  DefaultSessionRepository.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/16/25.
//

import Foundation
import Moya

final class DefaultSessionRepository: SessionRepository {
    private let provider = MoyaProvider<AuthAPI>()

    func refreshAccessToken(refreshToken: String, completion: @escaping (Result<String, Error>) -> Void) {
        provider.request(.refreshToken(token: refreshToken)) { result in
            switch result {
            case .success(let response):
                let newToken = try? JSONDecoder().decode(AuthTokenResponse.self, from: response.data).accessToken
                if let token = newToken {
                    completion(.success(token))
                } else {
                    completion(.failure(NSError(domain: "Decode", code: -1, userInfo: [
                        NSLocalizedDescriptionKey: "accessToken 파싱 실패"
                    ])))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
