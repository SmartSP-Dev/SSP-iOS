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

    var body: some View {
        VStack(spacing: 0) {
            // 상단 타이틀
            Text("과목 수정")
                .font(.title2.bold())
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.vertical, 20)
                .background(Color.white)

            // 과목 리스트
            ScrollView {
                LazyVStack(spacing: 14) {
                    ForEach(viewModel.subjects) { subject in
                        HStack {
                            Text(subject.name)
                                .font(.body.weight(.semibold))

                            Spacer()

                            Text("\(subject.time)분")
                                .foregroundColor(.gray)
                                .font(.subheadline)

                            Spacer()

                            // 삭제 버튼
                            Button(action: {
                                viewModel.removeSubject(subject)
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
                }
                .padding(.horizontal)
                .padding(.top, 10)
            }

            // 과목 추가 입력 영역
            VStack(spacing: 12) {
                Divider()

                HStack(spacing: 12) {
                    TextField("과목 이름", text: $newSubjectName)
                        .padding(10)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)

                    Button(action: {
                        let subject = StudySubject(name: newSubjectName, time: 0)
                        viewModel.addSubject(subject)
                        newSubjectName = ""
                    }) {
                        Text("추가")
                            .font(.subheadline.bold())
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .disabled(newSubjectName.trimmingCharacters(in: .whitespaces).isEmpty)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .background(Color.white)
        }
        .background(Color.white)
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    let mockViewModel = SubjectManageViewModel()
    mockViewModel.subjects = [
        StudySubject(name: "수학", time: 120),
        StudySubject(name: "영어", time: 90),
        StudySubject(name: "과학", time: 45)
    ]
    return SubjectManageView(viewModel: mockViewModel)
}
