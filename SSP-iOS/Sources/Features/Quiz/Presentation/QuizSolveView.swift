//
//  QuizSolveView.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/29/25.
//

import SwiftUI

import SwiftUI

struct QuizSolveView: View {
    @StateObject var viewModel: QuizSolveViewModel
    @State private var showModal: Bool = false
    @State private var showExitAlert: Bool = false
    @State private var shuffledOptionsMap: [Int: [String]] = [:]

    var body: some View {

        ZStack {
            mainContent
            if showModal {
                answerModal
            }
        }
        .task {
            await viewModel.loadQuizDetail()
        }
    }

    private var mainContent: some View {
        Group {
            if let result = viewModel.result {
                QuizResultSummaryView(result: result)
            } else if viewModel.quizzes.isEmpty {
                ProgressView("문제를 불러오는 중입니다...")
                    .padding()
            } else {
                VStack(alignment: .center, spacing: 24) {
                    if viewModel.isFinished {
                        Text("퀴즈 제출 중입니다...")
                            .onAppear {
                                Task {
                                    try? await Task.sleep(nanoseconds: 1_000_000_000) // 1초 대기
                                    await viewModel.submitQuiz()
                                }
                            }
                    } else {
                        questionTitle
                        questionBody
                        submitButton
                    }
                }
                .padding()
            }
        }
        .navigationTitle("퀴즈 진행 중")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    if viewModel.result != nil {
                        DIContainer.shared.makeAppRouter().goBack()
                    } else {
                        showExitAlert = true
                    }
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black.opacity(0.7))
                    Text("Back")
                        .foregroundColor(.black.opacity(0.7))
                }
            }
        }
        .onChange(of: viewModel.currentIndex) {
            let questionNumber = viewModel.currentQuestion.quizNumber
            if shuffledOptionsMap[questionNumber] == nil {
                shuffledOptionsMap[questionNumber] = viewModel.currentQuestion.options.shuffled()
            }
        }
        .alert(isPresented: $showExitAlert) {
            Alert(
                title: Text("정말 나가시겠습니까?"),
                message: Text("퀴즈는 저장되지 않습니다."),
                primaryButton: .destructive(Text("나가기")) {
                    DIContainer.shared.makeAppRouter().goBack()
                },
                secondaryButton: .cancel(Text("취소"))
            )
        }
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
                ForEach(currentShuffledOptions, id: \.self) { option in
                    Button(action: {
                        viewModel.selectedAnswer = option
                    }) {
                        Text(option)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(12)
                            .foregroundStyle(Color.black)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(
                                        viewModel.selectedAnswer == option ? Color.black : Color.clear,
                                        lineWidth: 2
                                    )
                            )
                    }
                }
            }

        case .ox:
            HStack(spacing: 20) {
                ForEach(["O", "X"], id: \.self) { option in
                    Button(action: {
                        viewModel.selectedAnswer = option
                    }) {
                        Text(option)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                viewModel.selectedAnswer == option
                                ? Color.black.opacity(0.4)
                                : Color.black.opacity(0.1)
                            )
                            .foregroundColor(
                                viewModel.selectedAnswer == option
                                ? .white
                                : .black
                            )
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.black, lineWidth: viewModel.selectedAnswer == option ? 2 : 1)
                            )
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
                .background(Color.black.opacity(0.7))
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
                
                Button(action : {
                    viewModel.nextQuestion()
                    showModal = false
                }) {
                    Text("다음 문제")
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.black.opacity(0.7))
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
    
    private var currentShuffledOptions: [String] {
        let questionNumber = viewModel.currentQuestion.quizNumber
        return shuffledOptionsMap[questionNumber] ?? viewModel.currentQuestion.options
    }
}
