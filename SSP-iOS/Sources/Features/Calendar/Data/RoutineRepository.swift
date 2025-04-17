//
//  RoutineRepository.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/16/25.
//

import Foundation

protocol RoutineRepository {
    func fetchRoutines() -> [RoutineItem]
    func fetchCheckStates(for date: Date) -> [UUID: Bool]

    func toggleRoutineCheck(id: UUID, for date: Date)
    func addRoutine(title: String)
    func addRoutineItem(_ item: RoutineItem)
    func deleteRoutine(at indexSet: IndexSet)

    func saveAll()  // optional: 앱 종료 직전 저장용
}

