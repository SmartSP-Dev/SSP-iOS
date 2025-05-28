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

    init(fetchProfileUseCase: FetchMyProfileUseCase) {
        self.fetchProfileUseCase = fetchProfileUseCase
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
}
