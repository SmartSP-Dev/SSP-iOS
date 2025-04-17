//
//  RoutineAddView.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/16/25.
//

import SwiftUI

struct RoutineAddView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: RoutineViewModel
    @State private var inputText: String = ""

    var body: some View {
        VStack {
            Text("오늘의 루틴을 확인하세요!")
                .font(.title3)
                .padding(.top, 32)

            Spacer()

            VStack(spacing: 12) {
                ForEach(viewModel.routines) { item in
                    Text(item.title)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 8).stroke(Color.blue.opacity(0.5), lineWidth: 1))
                }

                TextField("루틴 추가", text: $inputText)
                    .textFieldStyle(.roundedBorder)
            }
            .padding(.horizontal)

            Spacer()

            Button(action: {
                if !inputText.trimmingCharacters(in: .whitespaces).isEmpty {
                    viewModel.addRoutine(title: inputText)
                    dismiss()
                }
            }) {
                Text("추가")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            .padding(.bottom, 24)
        }
    }
}
