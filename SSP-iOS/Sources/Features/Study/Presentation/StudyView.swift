//
//  StudyView.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/17/25.
//

import SwiftUI

struct StudyView: View {
    @StateObject private var viewModel = StudyViewModel()
    @State private var isPresentingModal = false
    @State private var isStudyingModeActive = false
    @State private var isPresentingStartModal = false

    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Text("루디")
                    .font(.PretendardExtraBold24)
                    .underline()
                    .foregroundStyle(Color("mainColor800"))

                Text("님 오늘도 공부를 시작해볼까요?")
                    .font(.PretendardBold16)
                    .padding(.top, 12)
                    .foregroundStyle(Color("mainColor800"))

                Spacer()
            }
            Spacer()
            
            SectionView(
                title: "이번 달 학습량",
                showsButton: true,
                contentHeight: 200,
                buttonAction: {
                    // 과목 추가 로직
                }
            ) {
                ForEach(viewModel.subjects) { subject in
                    SubjectCardView(subject: subject)
                }
            }
            Spacer()
            
            SectionView(
                title: "이번 달 학습량",
                showsButton: true,
                contentHeight: 300,
                buttonAction: {
                    // 과목 추가 로직
                }
            ) {
                ForEach(viewModel.subjects) { subject in
                    SubjectCardView(subject: subject)
                }
            }
            Spacer()
            Spacer()
            Button(action: {
                isPresentingStartModal = true
            }) {
                Text("학습 기록 시작")
                    .font(.PretendardBold24)
                    .padding()
                    .foregroundStyle(Color.white)
                    .background(Color("mainColor800"))
                    .clipShape(.buttonBorder)
            }
            .fullScreenCover(isPresented: $isStudyingModeActive) {
                TimerStudyView(onEnd: {
                    isStudyingModeActive = false
                    viewModel.stopStudy()
                }, viewModel: viewModel)
            }
            .sheet(isPresented: $isPresentingStartModal) {
                StudyStartModalView(
                    onStart: {
                        viewModel.startStudy()
                        isPresentingStartModal = false
                        isStudyingModeActive = true // ✅ 전체 화면 전환
                    }
                )
            }

            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    StudyView()
}
