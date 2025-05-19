//
//  MockRoutineRepository.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/19/25.
//

import Foundation

final class MockRoutineRepository: RoutineRepository {
    func fetchRoutines(date: Date, completion: @escaping (Result<[Routine], Error>) -> Void) {
        completion(.success([
            Routine(id: 1, title: "영어 단어 외우기", startDate: date, isCompleted: false),
            Routine(id: 2, title: "운동하기", startDate: date, isCompleted: true)
        ]))
    }

    func addRoutine(title: String, completion: @escaping (Result<Void, Error>) -> Void) {
        completion(.success(()))
    }

    func toggleRoutineCheck(routineId: Int, date: Date, completed: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        completion(.success(()))
    }

    func deleteRoutine(routineId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        completion(.success(()))
    }

    func fetchSummary(completion: @escaping (Result<[RoutineSummaryDTO], Error>) -> Void) {
        completion(.success([]))
    }
}
