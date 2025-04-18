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
    @ObservedObject var viewModel: StudyViewModel

    @State private var selectedIndex: Int = 0

    var body: some View {
        VStack(spacing: 20) {
            Text("학습할 과목을 선택해주세요")
                .font(.title3)

            Picker("과목 선택", selection: $selectedIndex) {
                ForEach(0..<viewModel.subjects.count, id: \.self) { index in
                    Text(viewModel.subjects[index].name)
                }
            }
            .pickerStyle(.menu) // 드롭다운 스타일
            .padding()

            Button("시작") {
                viewModel.selectedSubject = viewModel.subjects[selectedIndex]
                onStart()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(8)

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
