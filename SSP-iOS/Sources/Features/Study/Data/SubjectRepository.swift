//
//  SubjectRepository.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/14/25.
//

import Foundation
import Moya

protocol SubjectRepository {
    func createSubject(_ name: String, completion: @escaping (Result<SubjectCreateResponseDTO, Error>) -> Void)
    func fetchSubjects(range: String, completion: @escaping (Result<[SubjectDTO], Error>) -> Void)
    func deleteSubject(id: Int, completion: @escaping (Result<Void, Error>) -> Void)
    func fetchWeeklySubjects(completion: @escaping (Result<[WeeklyStudyRecord], Error>) -> Void)
    func uploadRecord(_ dto: StudyRecordRequestDTO, completion: @escaping (Result<Void, Error>) -> Void)

}

final class SubjectRepositoryImpl: SubjectRepository {
    private let provider: MoyaProvider<SubjectAPI>

    init(provider: MoyaProvider<SubjectAPI> = MoyaProvider<SubjectAPI>()) {
        self.provider = provider
    }

    func createSubject(_ name: String, completion: @escaping (Result<SubjectCreateResponseDTO, Error>) -> Void) {
        provider.request(.create(subject: name)) { result in
            switch result {
            case .success(let response):
                print("과목 생성")
                print("[Auth] 상태코드: \(response.statusCode)")
                print("[Auth] 응답: \(String(data: response.data, encoding: .utf8) ?? "nil")")

                do {
                    let subject = try JSONDecoder().decode(SubjectCreateResponseDTO.self, from: response.data)
                    completion(.success(subject))
                } catch {
                    completion(.failure(error))
                }

            case .failure(let error):
                print("[Auth] 에러: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }

    func fetchSubjects(range: String, completion: @escaping (Result<[SubjectDTO], Error>) -> Void) {
        provider.request(.fetchSubjects(range: range)) { result in
            switch result {
            case .success(let response):
                print("과목 불러오기")
                print("[API] 상태 코드: \(response.statusCode)")
                print("[API] 응답 바디: \(String(data: response.data, encoding: .utf8) ?? "nil")")

                do {
                    let subjects = try JSONDecoder().decode([SubjectDTO].self, from: response.data)
                    completion(.success(subjects))
                } catch {
                    print("[Decode 에러] \(error)")
                    completion(.failure(error))
                }

            case .failure(let error):
                print("[요청 실패] \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    func deleteSubject(id: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        provider.request(.delete(id: id)) { result in
            switch result {
            case .success(let response):
                print("과목 삭제")
                if response.statusCode == 204 {
                    completion(.success(()))
                } else {
                    completion(.failure(NSError(domain: "", code: response.statusCode)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchWeeklySubjects(completion: @escaping (Result<[WeeklyStudyRecord], Error>) -> Void) {
        provider.request(.fetchSubjects(range: "week")) { result in
            switch result {
            case .success(let response):
                print("week 과목 조회")
                do {
                    let dtos = try JSONDecoder().decode([WeeklySubjectDTO].self, from: response.data)
                    let records = dtos.map {
                        WeeklyStudyRecord(subjectName: $0.subject, totalMinutes: $0.totalStudyTime / 60)
                    }
                    completion(.success(records))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func uploadRecord(_ dto: StudyRecordRequestDTO, completion: @escaping (Result<Void, Error>) -> Void) {
        provider.request(.uploadRecord(dto)) { result in
            switch result {
            case .success(let response):
                print("학습 기록 업로드")
                if (200..<300).contains(response.statusCode) {
                    completion(.success(()))
                } else {
                    completion(.failure(NSError(domain: "", code: response.statusCode)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchMonthlyStats(completion: @escaping (Result<MonthlySummaryDTO, Error>) -> Void) {
        provider.request(.fetchMonthlyStats) { result in
            switch result {
            case .success(let response):
                print("month 과목 조회")
                do {
                    let dto = try JSONDecoder().decode(MonthlySummaryDTO.self, from: response.data)
                    completion(.success(dto))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}
