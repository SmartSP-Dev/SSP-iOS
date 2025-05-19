//
//  RoutineViewModel.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/16/25.
//

import Foundation
import SwiftUI

@MainActor
final class RoutineViewModel: ObservableObject {
    @Published var routines: [Routine] = []
    @Published var selectedDate: Date = Date()
    @Published var isLoading = false

    private let repository: RoutineRepository

    init(repository: RoutineRepository) {
        self.repository = repository
        Task {
            await fetchRoutines(for: selectedDate)
        }
    }

    func fetchRoutines(for date: Date) async {
        isLoading = true
        defer { isLoading = false }

        await withCheckedContinuation { continuation in
            repository.fetchRoutines(date: date) { result in
                switch result {
                case .success(let fetched):
                    self.routines = fetched
                case .failure:
                    self.routines = []
                }
                continuation.resume()
            }
        }
    }

    func addRoutine(title: String) async {
        await withCheckedContinuation { continuation in
            repository.addRoutine(title: title) { _ in
                Task {
                    await self.fetchRoutines(for: self.selectedDate)
                }
                continuation.resume()
            }
        }
    }

    func toggleCheck(for routine: Routine) async {
        let newCompleted = !routine.isCompleted
        await withCheckedContinuation { continuation in
            repository.toggleRoutineCheck(
                routineId: routine.id,
                date: selectedDate,
                completed: newCompleted
            ) { _ in
                Task {
                    await self.fetchRoutines(for: self.selectedDate)
                }
                continuation.resume()
            }
        }
    }

    func deleteRoutine(id: Int) async {
        await withCheckedContinuation { continuation in
            repository.deleteRoutine(routineId: id) { _ in
                Task {
                    await self.fetchRoutines(for: self.selectedDate)
                }
                continuation.resume()
            }
        }
    }

    var completionRatio: Double {
        guard !routines.isEmpty else { return 0 }
        let done = routines.filter(\.isCompleted).count
        return Double(done) / Double(routines.count)
    }
}
