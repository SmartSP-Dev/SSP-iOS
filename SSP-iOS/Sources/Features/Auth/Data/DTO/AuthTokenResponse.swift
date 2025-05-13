//
//  AuthTokenResponse.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/13/25.
//

import Foundation

struct AuthTokenResponse: Decodable {
    let accessToken: String
    let refreshToken: String
}

