//
//  QuizSolveView.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/29/25.
//

import SwiftUI

struct QuizSolveView: View {
    @StateObject var viewModel = QuizSolveViewModel()

    var body: some View {
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
                    Text("Q\(viewModel.currentIndex + 1). \(viewModel.currentQuestion.title)")
                        .font(.title3)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)

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

                    if viewModel.showAnswer {
                        Text(viewModel.selectedAnswer == viewModel.currentQuestion.answer ? "정답입니다!" : "오답입니다.")
                            .foregroundColor(viewModel.selectedAnswer == viewModel.currentQuestion.answer ? .green : .red)
                    }

                    Button(action: {
                        if viewModel.showAnswer {
                            viewModel.nextQuestion()
                        } else {
                            viewModel.submitAnswer()
                        }
                    }) {
                        Text(viewModel.showAnswer ? "다음 문제" : "정답 확인")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                }
            }
        }
        .padding()
    }
}

#Preview("객관식") {
    QuizSolveView(viewModel: {
        let vm = QuizSolveViewModel()
        vm.quizzes = [MockQuizData.sampleQuestions[1]]  // 객관식
        return vm
    }())
}

#Preview("OX") {
    QuizSolveView(viewModel: {
        let vm = QuizSolveViewModel()
        vm.quizzes = [MockQuizData.sampleQuestions[0]]  // OX
        return vm
    }())
}

#Preview("빈칸") {
    QuizSolveView(viewModel: {
        let vm = QuizSolveViewModel()
        vm.quizzes = [MockQuizData.sampleQuestions[2]]  // 빈칸
        return vm
    }())
}
