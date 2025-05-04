//
//  DummyRoutineRepository.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/16/25.
//

import Foundation

final class DummyRoutineRepository: RoutineRepository {
    private var dummyRoutines: [RoutineItem] = [
        RoutineItem(id: UUID(), title: "아침 운동", createdDate: Date()),
        RoutineItem(id: UUID(), title: "코딩 공부", createdDate: Date()),
        RoutineItem(id: UUID(), title: "책 읽기", createdDate: Date())
    ]

    func fetchRoutines() -> [RoutineItem] {
        return dummyRoutines
    }

    func fetchCheckStates(for date: Date) -> [UUID: Bool] {
        return [dummyRoutines[0].id: true, dummyRoutines[1].id: false]
    }

    func toggleRoutineCheck(id: UUID, for date: Date) {}
    func addRoutine(title: String) {}
    func addRoutineItem(_ item: RoutineItem) {}
    func deleteRoutine(at indexSet: IndexSet) {}
    func saveAll() {}
}
