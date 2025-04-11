//
//  KakaoRepository.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/13/25.
//

import Foundation

protocol KakaoRepository {
    func loginWithKakao() async throws -> String
}
