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
                            .foregroundColor(.black)
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

            Button("시작") {
                guard subjectViewModel.subjects.indices.contains(selectedIndex) else { return }
                timerViewModel.selectedSubject = subjectViewModel.subjects[selectedIndex]
                onStart()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(subjectViewModel.subjects.isEmpty ? Color.gray : Color.black)
            .foregroundColor(.white)
            .cornerRadius(8)
            .disabled(subjectViewModel.subjects.isEmpty)

            Button("취소", action: onCancel)
                .padding()
                .foregroundColor(.red)
        }
        .padding()
        .frame(maxWidth: 300)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
    }
}

#Preview {
    let timerVM = StudyTimerViewModel()
    let subjectVM = SubjectManageViewModel()
    subjectVM.subjects = [
        StudySubject(name: "수학", time: 120),
        StudySubject(name: "영어", time: 90),
        StudySubject(name: "과학", time: 45)
    ]

    return StudyStartModalView(
        onStart: {},
        onCancel: {},
        timerViewModel: timerVM,
        subjectViewModel: subjectVM
    )
}
