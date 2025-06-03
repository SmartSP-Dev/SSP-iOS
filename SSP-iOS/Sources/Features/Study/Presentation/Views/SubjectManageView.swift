//
//  SubjectManageView.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/18/25.
//

import SwiftUI

struct SubjectManageView: View {
    @ObservedObject var viewModel: SubjectManageViewModel
    @State private var newSubjectName: String = ""
    @State private var showDeleteAlert = false
    @State private var subjectToDelete: StudySubject?

    var body: some View {
        VStack(spacing: 0) {
            // 상단 타이틀
            Text("과목 수정")
                .font(.title2.bold())
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.vertical, 20)
                .background(Color.white)

            ScrollView {
                LazyVStack(spacing: 14) {
                    ForEach(viewModel.subjects) { subject in
                        HStack {
                            Text(subject.name)
                                .font(.body.weight(.semibold))
                                .frame(width: 130, alignment: .leading)
                                .multilineTextAlignment(.leading)

                            Text(subject.time.asMinutesString)
                                .foregroundColor(.gray)
                                .font(.subheadline)

                            Spacer()

                            Button(action: {
                                subjectToDelete = subject
                                showDeleteAlert = true
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                            .padding(.leading, 4)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                    }

                    // 과목 추가 입력창
                    Divider()
                        .padding(.top, 20)

                    HStack(spacing: 12) {
                        TextField("과목 이름", text: $newSubjectName)
                            .padding(10)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)

                        Button(action: {
                            let subject = StudySubject(studyId: -1, name: newSubjectName, time: 0)
                            viewModel.addSubject(subject)
                            newSubjectName = ""
                        }) {
                            Text("추가")
                                .font(.subheadline.bold())
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .background(Color.black.opacity(0.7))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .disabled(newSubjectName.trimmingCharacters(in: .whitespaces).isEmpty)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 30)
                }
                .padding(.horizontal)
                .padding(.top, 10)
            }
            .alert("정말 삭제하시겠습니까?", isPresented: $showDeleteAlert, presenting: subjectToDelete) { subject in
                Button("삭제", role: .destructive) {
                    viewModel.deleteSubject(subject)
                }
                Button("취소", role: .cancel) { }
            } message: { subject in
                Text("\"\(subject.name)\" 과목을 삭제하시겠습니까?\n학습한 시간도 같이 사라지게 됩니다.")
            }
        }
        .background(Color.white)
        .ignoresSafeArea(edges: .bottom)
    }
}
