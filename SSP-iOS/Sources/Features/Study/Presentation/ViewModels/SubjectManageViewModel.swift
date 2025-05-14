//
//  SubjectManageViewModel.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/19/25.
//

import Foundation

final class SubjectManageViewModel: ObservableObject {
    @Published var subjects: [StudySubject] = []
    private let repository: SubjectRepository

    init(repository: SubjectRepository = SubjectRepositoryImpl()) {
        self.repository = repository
        loadSubjectsFromServer()
    }

    func addSubject(_ subject: StudySubject) {
        repository.createSubject(subject.name) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let dto):
                    let newSubject = StudySubject(
                        studyId: dto.id,
                        name: dto.subject,
                        time: 0
                    )
                    self?.subjects.append(newSubject)
                    self?.saveSubjects()
                case .failure(let error):
                    print("과목 추가 실패: \(error)")
                }
            }
        }
    }

    func removeSubject(_ subject: StudySubject) {
        subjects.removeAll { $0 == subject }
        saveSubjects()
    }
    
    func deleteSubject(_ subject: StudySubject) {
        repository.deleteSubject(id: subject.studyId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.subjects.removeAll { $0.studyId == subject.studyId }
                    self?.saveSubjects()
                case .failure(let error):
                    print("삭제 실패: \(error)")
                }
            }
        }
    }

    func updateSubject(_ subject: StudySubject) {
        if let index = subjects.firstIndex(where: { $0.id == subject.id }) {
            subjects[index] = subject
            saveSubjects()
        }
    }

    private func loadSubjects() {
        self.subjects = UserDefaults.standard.loadSubjects()
    }

    private func saveSubjects() {
        UserDefaults.standard.saveSubjects(subjects)
    }
    
    func loadSubjectsFromServer() {
        repository.fetchSubjects(range: "all") { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let dtos):
                    self?.subjects = dtos.map {
                        StudySubject(
                            studyId: $0.studyId,
                            name: $0.subject,
                            time: $0.totalStudyTime ?? 0
                        )
                    }
                case .failure(let error):
                    print("과목 불러오기 실패: \(error)")
                }
            }
        }
    }

}
