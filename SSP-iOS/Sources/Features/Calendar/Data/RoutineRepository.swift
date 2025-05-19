//
//  RoutineRepository.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/16/25.
//

import Foundation

protocol RoutineRepository {
    func fetchRoutines(date: Date, completion: @escaping (Result<[Routine], Error>) -> Void)
    func addRoutine(title: String, completion: @escaping (Result<Void, Error>) -> Void)
    func toggleRoutineCheck(routineId: Int, date: Date, completed: Bool, completion: @escaping (Result<Void, Error>) -> Void)
    func deleteRoutine(routineId: Int, completion: @escaping (Result<Void, Error>) -> Void)
    func fetchSummary(completion: @escaping (Result<[RoutineSummaryDTO], Error>) -> Void)
}
