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
    private let repository: TimetableRepository

    @Published var rawLink: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var schedules: [ScheduleDay] = []

    init(
        useCase: SaveTimetableLinkUseCase,
        repository: TimetableRepository
    ) {
        self.saveUseCase = useCase
        self.repository = repository
    }

    func saveLink() {
        isLoading = true
        errorMessage = nil
        saveUseCase.executeRegister(link: rawLink) { [weak self] result in
            print("executeRegister 응답 도착: \(result)")
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success:
                    print("링크 저장 성공")
                    Task {
                        await self?.fetchMyTimetable()
                    }
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

    @MainActor
    func fetchMyTimetable() async {
        isLoading = true
        errorMessage = nil

        await withCheckedContinuation { continuation in
            repository.fetchMyTimetable { [weak self] result in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    switch result {
                    case .success(let schedules):
                        self?.schedules = schedules
                    case .failure(let error):
                        self?.errorMessage = error.localizedDescription
                        self?.schedules = []
                    }
                    continuation.resume()
                }
            }
        }
    }

}
