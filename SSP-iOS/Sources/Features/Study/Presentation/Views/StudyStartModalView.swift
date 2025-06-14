//
//  StudyStartModalView.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/17/25.
//

import SwiftUI

struct StudyStartModalView: View {
    let onStart: () -> Void
    let onCancel: () -> Void

    @ObservedObject var timerViewModel: StudyTimerViewModel
    @ObservedObject var subjectViewModel: SubjectManageViewModel

    @State private var selectedIndex: Int = 0

    var body: some View {
        VStack(spacing: 20) {
            Text("학습할 과목을 선택해주세요!")
                .font(.PretendardBold16)

            Menu {
                Picker("과목 선택", selection: $selectedIndex) {
                    ForEach(0..<subjectViewModel.subjects.count, id: \.self) { index in
                        Text(subjectViewModel.subjects[index].name)
                    }
                }
            } label: {
                HStack(spacing: 4) {
                    if subjectViewModel.subjects.indices .contains(selectedIndex) {
                        Text(subjectViewModel.subjects[selectedIndex].name)
                            .font(.PretendardMedium16)
                            .foregroundColor(.black.opacity(0.7))
                    } else {
                        Text("과목 없음")
                            .font(.PretendardMedium16)
                            .foregroundColor(.gray)
                    }

                    Image(systemName: "chevron.down")
                        .foregroundColor(.gray)
                        .font(.caption)
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            }

            Button(action: {
                guard subjectViewModel.subjects.indices.contains(selectedIndex) else { return }
                timerViewModel.selectedSubject = subjectViewModel.subjects[selectedIndex]
                onStart()

            }) {
                Text("시작")
                    .font(.PretendardMedium16)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(subjectViewModel.subjects.isEmpty ? Color.gray : Color.black.opacity(0.7))
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .disabled(subjectViewModel.subjects.isEmpty)

            Button(action: onCancel) {
                Text("취소")
                    .font(.PretendardMedium16)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .foregroundColor(.red)
                    .cornerRadius(8)
            }
        }
        .padding()
        .frame(maxWidth: 300)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
    }
}
