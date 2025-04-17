//
//  DummyRoutineRepository.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/16/25.
//

//import Foundation
//
//final class DummyRoutineRepository: RoutineRepository {
//    private let dummyRoutines: [RoutineItem] = [
//        RoutineItem(id: UUID(), title: "🧘‍♀️ 명상하기"),
//        RoutineItem(id: UUID(), title: "📖 책 읽기"),
//        RoutineItem(id: UUID(), title: "🏃‍♂️ 운동하기")
//    ]
//
//    func fetchRoutines() -> [RoutineItem] {
//        dummyRoutines
//    }
//
//    func fetchCheckStates(for date: Date) -> [UUID: Bool] {
//        Dictionary(uniqueKeysWithValues: dummyRoutines.map { ($0.id, Bool.random()) })
//    }
//
//    func toggleRoutineCheck(id: UUID, for date: Date) {}
//    func addRoutine(title: String) {}
//    func deleteRoutine(at indexSet: IndexSet) {}
//    func saveAll() {}
//}
