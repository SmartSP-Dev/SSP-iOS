//
//  ProfileViewModel.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/28/25.
//

import Foundation

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var profile: MemberProfileResponse?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let fetchProfileUseCase: FetchMyProfileUseCase
    private let updateProfileUseCase: UpdateProfileUseCase

    init(
        fetchProfileUseCase: FetchMyProfileUseCase,
        updateProfileUseCase: UpdateProfileUseCase
    ) {
        self.fetchProfileUseCase = fetchProfileUseCase
        self.updateProfileUseCase = updateProfileUseCase
    }

    func fetchProfile() async {
        isLoading = true
        defer { isLoading = false }

        do {
            self.profile = try await fetchProfileUseCase.execute()
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

    func updateProfile(name: String, university: String, department: String) async {
        isLoading = true
        defer { isLoading = false }

        do {
            self.profile = try await updateProfileUseCase.execute(
                name: name,
                university: university,
                department: department
            )
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}
