//
//  RoutineRepositoryImpl.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/19/25.
//

import Foundation

final class RoutineRepositoryImpl: RoutineRepository {
    private let remote: RoutineRemoteDataSource

    init(remote: RoutineRemoteDataSource) {
        self.remote = remote
    }

    func fetchRoutines(date: Date, completion: @escaping (Result<[Routine], Error>) -> Void) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: date)

        remote.fetchRoutines(date: dateString) { result in
            switch result {
            case .success(let dtos):
                let routines = dtos.map { dto in
                    Routine(
                        id: dto.routineId,
                        title: dto.title,
                        startDate: date, // or dto.startDate if API 제공
                        isCompleted: dto.completed
                    )
                }
                completion(.success(routines))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func addRoutine(title: String, completion: @escaping (Result<Void, Error>) -> Void) {
        remote.addRoutine(title: title, completion: completion)
    }

    func toggleRoutineCheck(routineId: Int, date: Date, completed: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let request = ToggleCheckRequest(routineId: routineId, date: formatter.string(from: date), completed: completed)
        remote.toggleCheck(request, completion: completion)
    }

    func deleteRoutine(routineId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        remote.deleteRoutine(id: routineId, completion: completion)
    }

    func fetchSummary(completion: @escaping (Result<[RoutineSummaryDTO], Error>) -> Void) {
        remote.fetchSummary(completion: completion)
    }
}
