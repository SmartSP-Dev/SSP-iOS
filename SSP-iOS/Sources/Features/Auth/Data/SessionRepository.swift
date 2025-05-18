//
//  SessionRepository.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/16/25.
//

import Foundation

protocol SessionRepository {
    func refreshAccessToken(refreshToken: String, completion: @escaping (Result<String, Error>) -> Void)
}
