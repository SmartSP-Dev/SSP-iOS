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
        print("[Repo] fetchMyProfile 호출됨")

        let response = try await provider.request(.fetchMyProfile)

        if let jsonString = String(data: response.data, encoding: .utf8) {
            print("[Repo] fetchMyProfile 응답: \(jsonString)")
        }

        return try JSONDecoder().decode(MemberProfileResponse.self, from: response.data)
    }
    
    func updateProfile(name: String, university: String, department: String) async throws -> MemberProfileResponse {
        print("[Repo] updateProfile 호출됨 with name: \(name), university: \(university), department: \(department)")

        let response = try await provider.request(.updateProfile(name: name, university: university, department: department))

        if let jsonString = String(data: response.data, encoding: .utf8) {
            print("[Repo] updateProfile 응답: \(jsonString)")
        }

        return try JSONDecoder().decode(MemberProfileResponse.self, from: response.data)
    }
}
