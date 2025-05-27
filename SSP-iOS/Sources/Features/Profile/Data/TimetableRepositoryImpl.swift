//
//  TimetableRepositoryImpl.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/27/25.
//

import Moya

final class TimetableRepositoryImpl: TimetableRepository {
    private let provider: MoyaProvider<TimetableAPI>

    init(provider: MoyaProvider<TimetableAPI>) {
        self.provider = provider
    }

    func registerTimetable(_ url: String, completion: @escaping (Result<Void, Error>) -> Void) {
        provider.request(.registerTimetable(link: url)) { result in
            switch result {
            case .success(let response):
                if (200..<300).contains(response.statusCode) {
                    completion(.success(()))
                } else {
                    completion(.failure(MoyaError.statusCode(response)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
