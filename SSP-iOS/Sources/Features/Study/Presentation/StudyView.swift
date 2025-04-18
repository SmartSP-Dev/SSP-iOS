//
//  StudyView.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/17/25.
//

import SwiftUI

struct StudyView: View {
    @StateObject private var viewModel = StudyViewModel()
    @State private var isPresentingStartModal = false
    @State private var isStudyingModeActive = false
    @State private var isPresentingSubjectManageSheet = false

    var body: some View {
        ZStack {
            mainContent

            if isPresentingStartModal {
                dimmedBackground
                startModal
            }
        }
    }

    // MARK: - Main Content

    private var mainContent: some View {
        VStack(spacing: 24) {
            greetingSection

            // 이번 주 통계
            SectionView(
                title: "이번 주 통계",
                showsButton: true,
                contentHeight: 250,
                buttonAction: {
                    isPresentingSubjectManageSheet = true
                }
            ) {
                ForEach(viewModel.weeklyRecords) { record in
                    HStack {
                        Text(record.subjectName)
                            .font(.body.weight(.semibold))
                        Spacer()
                        Text("\(record.totalMinutes)분")
                            .foregroundColor(.gray)
                            .font(.subheadline)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                }
            }
            .sheet(isPresented: $isPresentingSubjectManageSheet) {
                SubjectManageView(viewModel: viewModel)
            }

            // 이번 달 학습량 요약
            MonthlySummarySectionView(
                daysStudied: viewModel.totalStudyDays,
                totalMinutes: viewModel.totalMonthlyMinutes,
                averageMinutes: viewModel.averageMinutesPerDay,
                bestDay: viewModel.bestStudyDayFormatted,
                bestDayMinutes: viewModel.bestStudyDayMinutes
            )

            startButton
        }
        .padding()
        .disabled(isPresentingStartModal)
        .blur(radius: isPresentingStartModal ? 3 : 0)
        .fullScreenCover(isPresented: $isStudyingModeActive) {
            TimerStudyView(
                onEnd: {
                    isStudyingModeActive = false
                    viewModel.stopStudy()
                },
                viewModel: viewModel
            )
        }
    }

    // MARK: - Greeting

    private var greetingSection: some View {
        VStack(spacing: 4) {
            Text("루디")
                .font(.PretendardExtraBold24)
                .underline()
                .foregroundStyle(Color.black)

            Text("님 오늘도 공부를 시작해볼까요?")
                .font(.PretendardBold16)
                .foregroundStyle(Color.black)
        }
    }

    // MARK: - Start Button

    private var startButton: some View {
        Button(action: {
            isPresentingStartModal = true
        }) {
            Text("학습 기록 시작")
                .font(.PretendardBold24)
                .padding()
                .foregroundStyle(.white)
                .background(.black)
                .clipShape(.buttonBorder)
        }
    }

    // MARK: - Modal Overlay

    private var dimmedBackground: some View {
        Color.black.opacity(0.4)
            .ignoresSafeArea()
    }

    private var startModal: some View {
        StudyStartModalView(
            onStart: {
                isPresentingStartModal = false
                viewModel.startStudy()
                isStudyingModeActive = true
            },
            onCancel: {
                isPresentingStartModal = false
            },
            viewModel: viewModel
        )
    }
}

#Preview {
    let viewModel = StudyViewModel()
    viewModel.weeklyRecords = [
        WeeklyStudyRecord(subjectName: "수학", totalMinutes: 120),
        WeeklyStudyRecord(subjectName: "영어", totalMinutes: 60)
    ]
    viewModel.totalStudyDays = 15
    viewModel.totalMonthlyMinutes = 900
    viewModel.averageMinutesPerDay = 60.0
    viewModel.bestStudyDayFormatted = "4월 10일"
    viewModel.bestStudyDayMinutes = 120

    return StudyView()
}
