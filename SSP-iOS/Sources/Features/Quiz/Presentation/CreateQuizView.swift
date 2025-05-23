//
//  CreateQuizView.swift
//  SSP-iOS
//
//  Created by ChatGPT on 4/27/25.
//

import SwiftUI

struct CreateQuizView: View {
    @StateObject private var viewModel: CreateQuizViewModel
    @State private var isDocumentPickerPresented = false
    @State private var showUnsupportedFileAlert = false
    @State private var showErrorAlert = false
    @State private var isSuccess = false

    init(viewModel: CreateQuizViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            mainContent
            if viewModel.isLoading {
                loadingOverlay
            }
        }
    }

    private var mainContent: some View {
        ScrollView {
            ZStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 20) {
                    quizNoticeSection
                    fileAndKeywordSection
                    Spacer()
                }
                .padding()
            }
            createQuizButtonSection
                .padding()
        }
        .background(Color.white.edgesIgnoringSafeArea(.all))
        .navigationTitle("퀴즈 만들기")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    DIContainer.shared.makeAppRouter().goBack()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                    Text("Back")
                        .foregroundColor(.black)
                }
            }
        }
    }

    private var loadingOverlay: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            VStack(spacing: 16) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
                Text("퀴즈를 제작하는 데 약 10초-20초 정도 소요됩니다.")
                    .foregroundColor(.white)
                    .font(.body)
                    .multilineTextAlignment(.center)
            }
            .padding(40)
            .background(Color.black.opacity(0.7))
            .cornerRadius(16)
        }
    }

    private var quizNoticeSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("퀴즈 만들기 주의사항")
                .font(.headline)
                .padding(.horizontal)

            Text("- 파일은 jpg, jpeg, png, pdf 파일만 지원됩니다.\n- 파일 업로드 후 저장 버튼을 꼭 눌러주세요!\n- 키워드는 문제를 생성하는 데 사용됩니다.\n- 문제 유형을 정확히 선택하세요.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
                .padding(.horizontal)
        }
    }

    private var fileAndKeywordSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 8) {
                Text("PDF 또는 이미지 업로드")
                    .font(.subheadline)

                Text(viewModel.fileURL?.lastPathComponent ?? "파일을 첨부해주세요")
                    .font(.PretendardLight14)

                HStack(spacing: 10) {
                    if viewModel.fileURL == nil {
                        Button(action: {
                            isDocumentPickerPresented = true
                        }) {
                            Text("업로드")
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.black)
                                .cornerRadius(8)
                        }

                        Button(action: {}) {
                            Text("저장")
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.gray)
                                .cornerRadius(8)
                        }
                    } else {
                        Button(action: {
                            viewModel.fileURL = nil
                            viewModel.errorMessage = nil
                        }) {
                            Text("삭제")
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.red)
                                .cornerRadius(8)
                        }

                        Button(action: {
                            Task {
                                await viewModel.uploadFile()
                                if viewModel.errorMessage != nil {
                                    isSuccess = false
                                    showErrorAlert = true
                                } else if viewModel.successMessage != nil {
                                    isSuccess = true
                                    showErrorAlert = true
                                }
                            }
                        }) {
                            Text("저장")
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.black)
                                .cornerRadius(8)
                        }
                        .disabled(viewModel.fileURL == nil)
                    }
                }
                .sheet(isPresented: $isDocumentPickerPresented) {
                    DocumentPicker(fileURL: $viewModel.fileURL, showUnsupportedFileAlert: $showUnsupportedFileAlert)
                }
                .alert(isPresented: $showUnsupportedFileAlert) {
                    Alert(
                        title: Text("지원하지 않는 파일 형식"),
                        message: Text("jpg, jpeg, png, pdf 파일만 업로드할 수 있습니다."),
                        dismissButton: .default(Text("확인"))
                    )
                }
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("퀴즈 이름")
                    .font(.subheadline)
                TextField("퀴즈 이름을 입력하세요", text: $viewModel.QuizTitle)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("키워드")
                    .font(.subheadline)
                TextField("키워드를 입력하세요", text: $viewModel.keyword)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("문제 유형")
                    .font(.subheadline)
                ForEach(QuizType.allCases, id: \.self) { type in
                    HStack {
                        Image(systemName: viewModel.selectedType == type ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(.black)
                            .onTapGesture {
                                viewModel.selectedType = type
                            }
                        Text(type.displayName)
                            .onTapGesture {
                                viewModel.selectedType = type
                            }
                    }
                }
            }
        }
        .padding(.horizontal)
    }

    private var createQuizButtonSection: some View {
        VStack(spacing: 20) {
            Button(action: {
                Task {
                    await viewModel.generateQuiz()
                    if viewModel.errorMessage != nil {
                        isSuccess = false
                        showErrorAlert = true
                    } else if viewModel.successMessage != nil {
                        isSuccess = true
                        showErrorAlert = true
                    }
                }
            }) {
                Text("퀴즈 제작")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isSuccess == false ? Color.gray : Color.black)
                    .cornerRadius(8)
            }
            .padding(.horizontal)
            .disabled(isSuccess == false)
        }
        .alert(isPresented: $showErrorAlert) {
            Alert(
                title: Text(isSuccess ? "업로드 성공" : "업로드 실패"),
                message: Text(isSuccess ? (viewModel.successMessage ?? "") : (viewModel.errorMessage ?? "알 수 없는 오류")),
                dismissButton: .default(Text("확인")) {
                    viewModel.errorMessage = nil
                    viewModel.successMessage = nil
                    if isSuccess {
                        DIContainer.shared.makeAppRouter().goBack()
                    }
                }
            )
        }
    }
}

extension QuizType {
    var displayName: String {
        switch self {
        case .multipleChoice: return "객관식"
        case .ox: return "O/X"
        case .fillInTheBlank: return "빈칸 채우기"
        }
    }
}
