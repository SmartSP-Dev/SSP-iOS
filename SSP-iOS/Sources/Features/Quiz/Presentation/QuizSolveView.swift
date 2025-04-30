//
//  QuizSolveView.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/29/25.
//

import SwiftUI

struct QuizSolveView: View {
    @StateObject var viewModel = QuizSolveViewModel()
    @State private var showModal: Bool = false

    var body: some View {
        ZStack {
            mainContent
            if showModal {
                answerModal
            }
        }
    }

    private var mainContent: some View {
        VStack(alignment: .center, spacing: 24) {
            if viewModel.isFinished {
                Spacer()
                Text("🎉 모든 문제를 푸셨습니다!")
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                Spacer()
            } else {
                VStack(spacing: 20) {
                    questionTitle
                    questionBody
                    submitButton
                }
            }
        }
        .padding()
    }

    private var questionTitle: some View {
        Text("Q\(viewModel.currentIndex + 1). \(viewModel.currentQuestion.title)")
            .font(.title3)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
    }

    @ViewBuilder
    private var questionBody: some View {
        switch viewModel.currentQuestion.type {
        case .multipleChoice:
            VStack(spacing: 12) {
                ForEach(viewModel.currentQuestion.options, id: \ .self) { option in
                    Button(action: {
                        viewModel.selectedAnswer = option
                    }) {
                        HStack {
                            Text(option)
                            Spacer()
                            if viewModel.selectedAnswer == option {
                                Image(systemName: "checkmark")
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                    }
                }
            }

        case .ox:
            HStack(spacing: 20) {
                ForEach(["O", "X"], id: \ .self) { option in
                    Button(action: {
                        viewModel.selectedAnswer = option
                    }) {
                        Text(option)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(12)
                    }
                }
            }

        case .fillInTheBlank:
            TextField("정답 입력", text: Binding(
                get: { viewModel.selectedAnswer ?? "" },
                set: { viewModel.selectedAnswer = $0 }
            ))
            .textFieldStyle(.roundedBorder)
            .padding(.horizontal)
        }
    }

    private var submitButton: some View {
        Button(action: {
            if viewModel.selectedAnswer != nil {
                showModal = true
            }
        }) {
            Text("정답 확인")
                .bold()
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.black)
                .foregroundColor(.white)
                .cornerRadius(12)
        }
    }

    private var answerModal: some View {
        ZStack {
            Color.black.opacity(0.8).ignoresSafeArea()
            VStack(spacing: 16) {
                Text(viewModel.selectedAnswer == viewModel.currentQuestion.answer ? "정답입니다!" : "오답입니다.")
                    .font(.headline)
                    .foregroundColor(viewModel.selectedAnswer == viewModel.currentQuestion.answer ? .green : .red)

                VStack(alignment: .leading, spacing: 8) {
                    Text("정답: \(viewModel.currentQuestion.answer)")
                        .bold()
                    Text("해설: 이 문제는 예시 해설입니다. 실제 해설은 서버로부터 받아올 수 있습니다.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)

                Button("다음 문제") {
                    viewModel.nextQuestion()
                    showModal = false
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.black)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .padding()
            .frame(maxWidth: 300)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(radius: 10)
        }
    }
}

#Preview("객관식") {
    QuizSolveView(viewModel: {
        let vm = QuizSolveViewModel()
        vm.quizzes = [MockQuizData.sampleQuestions[1]]
        return vm
    }())
}

#Preview("OX") {
    QuizSolveView(viewModel: {
        let vm = QuizSolveViewModel()
        vm.quizzes = [MockQuizData.sampleQuestions[0]]
        return vm
    }())
}

#Preview("빈칸") {
    QuizSolveView(viewModel: {
        let vm = QuizSolveViewModel()
        vm.quizzes = [MockQuizData.sampleQuestions[2]]
        return vm
    }())
}
