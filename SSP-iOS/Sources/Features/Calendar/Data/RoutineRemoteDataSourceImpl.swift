//
//  RoutineRemoteDataSourceImpl.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/19/25.
//

import Foundation
import Moya

final class RoutineRemoteDataSourceImpl: RoutineRemoteDataSource {
    private let provider: MoyaProvider<RoutineAPI>

    init(provider: MoyaProvider<RoutineAPI> = MoyaProvider<RoutineAPI>()) {
        self.provider = provider
    }

    func fetchRoutines(date: String, completion: @escaping (Result<[RoutineResponseDTO], Error>) -> Void) {
        provider.request(.fetchRoutines(date: date)) { result in
            switch result {
            case .success(let response):
                do {
                    let routines = try JSONDecoder().decode([RoutineResponseDTO].self, from: response.data)
                    completion(.success(routines))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func addRoutine(title: String, completion: @escaping (Result<Void, Error>) -> Void) {
        provider.request(.addRoutine(title: title)) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func toggleCheck(_ request: ToggleCheckRequest, completion: @escaping (Result<Void, Error>) -> Void) {
        provider.request(.toggleCheck(routineId: request.routineId, date: request.date, completed: request.completed)) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func deleteRoutine(id: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        provider.request(.deleteRoutine(routineId: id)) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchSummary(completion: @escaping (Result<[RoutineSummaryDTO], Error>) -> Void) {
        provider.request(.fetchSummary) { result in
            switch result {
            case .success(let response):
                do {
                    let summary = try JSONDecoder().decode([RoutineSummaryDTO].self, from: response.data)
                    completion(.success(summary))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
