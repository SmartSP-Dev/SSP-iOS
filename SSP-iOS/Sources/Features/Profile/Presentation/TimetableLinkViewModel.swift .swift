//
//  TimetableLinkViewModel.swift .swift
//  SSP-iOS
//
//  Created by 황상환 on 5/27/25.
//

import Foundation

@MainActor
final class TimetableLinkViewModel: ObservableObject {
    private let saveUseCase: SaveTimetableLinkUseCase

    @Published var rawLink: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    init(useCase: SaveTimetableLinkUseCase) {
        self.saveUseCase = useCase
    }

    func saveLink() {
        isLoading = true
        errorMessage = nil
        saveUseCase.executeRegister(link: rawLink) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success:
                    print("링크 저장 성공")
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
