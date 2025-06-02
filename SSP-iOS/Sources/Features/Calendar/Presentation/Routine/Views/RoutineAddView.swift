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
        VStack (alignment: .center) {
            Text("루틴을 추가하고 삭제할 수 있어요")
                .font(.title3)
                .padding(.top, 32)
            Text("과거의 루틴은 삭제가 불가능해요!\n루틴을 삭제할 경우 금일 기준으로 반영됩니다!")
                .font(.subheadline)
                .padding(.top, 5)
                .multilineTextAlignment(.center)

            Spacer()

            VStack(spacing: 12) {
                ForEach(viewModel.routines) { routine in
                    HStack {
                        Text(routine.title)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Button(action: {
                            Task {
                                await viewModel.deleteRoutine(id: routine.id)
                            }
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 8).stroke(Color.black.opacity(0.5), lineWidth: 1))
                }

                TextField("루틴 추가", text: $inputText)
                    .textFieldStyle(.roundedBorder)
            }
            .padding(.horizontal)

            Spacer()

            Button(action: {
                Task {
                    let trimmed = inputText.trimmingCharacters(in: .whitespaces)
                    guard !trimmed.isEmpty else { return }
                    await viewModel.addRoutine(title: trimmed)
                    inputText = ""
                }
            }) {
                Text("추가")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            .padding(.bottom, 24)
        }
    }
}

#Preview {
    RoutineAddView(viewModel: RoutineViewModel(repository: MockRoutineRepository()))
}
