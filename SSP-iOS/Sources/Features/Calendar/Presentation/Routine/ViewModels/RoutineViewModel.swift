//
//  RoutineViewModel.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/16/25.
//

import Foundation
import SwiftUI

final class RoutineViewModel: ObservableObject {
    @Published var routines: [RoutineItem] = []
    @Published var checkStates: [UUID: Bool] = [:]
    @Published var selectedDate: Date = Date() {
        didSet {
            loadCheckStates(for: selectedDate)
        }
    }

    let repository: RoutineRepository
    private let currentDate: Date

    init(repository: RoutineRepository, date: Date = Date()) {
        self.repository = repository
        self.currentDate = date
        self.fetchData()
        self.selectedDate = date  // 초기 날짜 반영
    }

    func fetchData() {
        routines = repository.fetchRoutines()
        loadCheckStates(for: selectedDate)
    }

    func loadCheckStates(for date: Date) {
        checkStates = repository.fetchCheckStates(for: date)
    }

    func toggleCheck(for id: UUID) {
        repository.toggleRoutineCheck(id: id, for: selectedDate)
        loadCheckStates(for: selectedDate)
    }

    func addRoutine(title: String) {
        let new = RoutineItem(id: UUID(), title: title, createdDate: Date()) // 생성일자 명시
        repository.addRoutineItem(new)
        fetchData()
    }

    func deleteRoutine(at indexSet: IndexSet) {
        repository.deleteRoutine(at: indexSet)
        fetchData()
    }

    func saveIfNeeded() {
        repository.saveAll()
    }

    var visibleRoutines: [RoutineItem] {
        routines.filter { $0.createdDate.isSameOrBefore(selectedDate) }
    }

    var checkStatesForSelectedDate: [UUID: Bool] {
        checkStates
    }
}
