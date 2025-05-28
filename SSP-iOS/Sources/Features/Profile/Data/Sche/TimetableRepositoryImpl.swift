//
//  TimetableRepositoryImpl.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/27/25.
//

import Moya
import Foundation

final class TimetableRepositoryImpl: TimetableRepository {
    private let provider: MoyaProvider<TimetableAPI>

    init(provider: MoyaProvider<TimetableAPI>) {
        self.provider = provider
    }

    func registerTimetable(_ url: String, completion: @escaping (Result<Void, Error>) -> Void) {
        print("[Repo] registerTimetable 호출됨 with url: \(url)")

        provider.request(.registerTimetable(link: url)) { result in
            switch result {
            case .success(let response):
                print("[Repo] registerTimetable 응답 코드: \(response.statusCode)")
                print("[Repo] 응답 데이터: \(String(data: response.data, encoding: .utf8) ?? "nil")")

                if (200..<300).contains(response.statusCode) {
                    completion(.success(()))
                } else {
                    completion(.failure(MoyaError.statusCode(response)))
                }
            case .failure(let error):
                print("[Repo] registerTimetable 실패: \(error)")
                completion(.failure(error))
            }
        }
    }


    func fetchMyTimetable(completion: @escaping (Result<[ScheduleDay], Error>) -> Void) {
        print("[Repo] fetchMyTimetable 호출됨")

        provider.request(.fetchMyTimetable) { result in
            switch result {
            case .success(let response):
                print("[Repo] fetchMyTimetable 응답 코드: \(response.statusCode)")
                print("[Repo] 응답 데이터: \(String(data: response.data, encoding: .utf8) ?? "nil")")

                do {
                    let decoded = try JSONDecoder().decode(TimetableResponse.self, from: response.data)
                    print("[Repo] 디코딩 성공 - schedule count: \(decoded.payload.schedules.count)")
                    completion(.success(decoded.payload.schedules))
                } catch {
                    print("[Repo] 디코딩 실패: \(error)")
                    completion(.failure(error))
                }
            case .failure(let error):
                print("[Repo] fetchMyTimetable 실패: \(error)")
                completion(.failure(error))
            }
        }
    }

}
