//
//  RoutineRemoteDataSource.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/19/25.
//

import Foundation
import Moya

protocol RoutineRemoteDataSource {
    func fetchRoutines(date: String, completion: @escaping (Result<[RoutineResponseDTO], Error>) -> Void)
    func addRoutine(title: String, completion: @escaping (Result<Void, Error>) -> Void)
    func toggleCheck(_ request: ToggleCheckRequest, completion: @escaping (Result<Void, Error>) -> Void)
    func deleteRoutine(id: Int, completion: @escaping (Result<Void, Error>) -> Void)
    func fetchSummary(completion: @escaping (Result<[RoutineSummaryDTO], Error>) -> Void)
}
