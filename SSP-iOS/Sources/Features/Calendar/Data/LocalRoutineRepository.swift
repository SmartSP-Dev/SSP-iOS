//
//  LocalRoutineRepository.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/16/25.
//

import Foundation

final class LocalRoutineRepository: RoutineRepository {
    private let routineListKey = "routine_list"
    private let dateFormatter: DateFormatter

    private(set) var routines: [RoutineItem] = []
    private var checkStatesByDate: [String: [UUID: Bool]] = [:]  // 날짜 문자열 → 체크 상태

    init() {
        self.dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        loadRoutines()
        loadCheckStates()
    }

    func fetchRoutines() -> [RoutineItem] {
        routines
    }

    func fetchCheckStates(for date: Date) -> [UUID: Bool] {
        let key = dateFormatter.string(from: date)
        return checkStatesByDate[key] ?? [:]
    }

    func toggleRoutineCheck(id: UUID, for date: Date) {
        let key = dateFormatter.string(from: date)
        if checkStatesByDate[key] == nil {
            checkStatesByDate[key] = [:]
        }
        checkStatesByDate[key]?[id]?.toggle() ?? {
            checkStatesByDate[key]?[id] = true
        }()
        saveCheckStates()
    }

    func addRoutine(title: String) {
        let new = RoutineItem(id: UUID(), title: title, createdDate: Date())
        routines.append(new)
        saveRoutines()
    }
    
    func addRoutineItem(_ item: RoutineItem) {
        routines.append(item)
        saveRoutines()
    }

    func deleteRoutine(at indexSet: IndexSet) {
        for index in indexSet {
            let id = routines[index].id
            // 모든 날짜의 체크 기록에서도 제거
            for key in checkStatesByDate.keys {
                checkStatesByDate[key]?.removeValue(forKey: id)
            }
        }
        routines.remove(atOffsets: indexSet)
        saveRoutines()
        saveCheckStates()
    }

    func saveAll() {
        saveRoutines()
        saveCheckStates()
    }

    // MARK: - Private 저장/불러오기

    private func saveRoutines() {
        if let data = try? JSONEncoder().encode(routines) {
            UserDefaults.standard.set(data, forKey: routineListKey)
        }
    }

    private func saveCheckStates() {
        if let data = try? JSONEncoder().encode(checkStatesByDate) {
            UserDefaults.standard.set(data, forKey: "routine_check_states")
        }
    }

    private func loadRoutines() {
        if let data = UserDefaults.standard.data(forKey: routineListKey),
           let decoded = try? JSONDecoder().decode([RoutineItem].self, from: data) {
            self.routines = decoded
        }
    }

    private func loadCheckStates() {
        if let data = UserDefaults.standard.data(forKey: "routine_check_states"),
           let decoded = try? JSONDecoder().decode([String: [UUID: Bool]].self, from: data) {
            self.checkStatesByDate = decoded
        }
    }
}
