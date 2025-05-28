//
//  MemberRepository.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/28/25.
//

import Foundation
import Moya

protocol MemberRepository {
    func fetchMyProfile() async throws -> MemberProfileResponse
    func updateProfile(name: String, university: String, department: String) async throws -> MemberProfileResponse
}

final class MemberRepositoryImpl: MemberRepository {
    
    private let provider: MoyaProvider<MemberAPI>

    init(provider: MoyaProvider<MemberAPI>) {
        self.provider = provider
    }

    func fetchMyProfile() async throws -> MemberProfileResponse {
        let response = try await provider.request(.fetchMyProfile)
        return try JSONDecoder().decode(MemberProfileResponse.self, from: response.data)
    }
    
    func updateProfile(name: String, university: String, department: String) async throws -> MemberProfileResponse {
        let response = try await provider.request(.updateProfile(name: name, university: university, department: department))
        return try JSONDecoder().decode(MemberProfileResponse.self, from: response.data)
    }
}
