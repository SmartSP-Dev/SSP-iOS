//
//  MoyaProvider+Async.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/21/25.
//

import Foundation
import Moya

extension MoyaProvider {
    func request(_ target: Target) async throws -> Response {
        try await withCheckedThrowingContinuation { continuation in
            self.request(target) { result in
                switch result {
                case .success(let response):
                    continuation.resume(returning: response)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
