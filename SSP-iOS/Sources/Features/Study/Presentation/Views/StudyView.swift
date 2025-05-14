//
//  StudyView.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/17/25.
//

import SwiftUI

struct StudyView: View {
    let statisticsViewModel = StatisticsViewModel()

    @StateObject private var timerViewModel = StudyTimerViewModel()
    @StateObject private var subjectViewModel = SubjectManageViewModel(
        repository: SubjectRepositoryImpl()
    )
    @StateObject private var statsViewModel = StatisticsViewModel()

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
        .onAppear {
           statsViewModel.loadWeeklyStudyFromServer()
            statsViewModel.loadMonthlyStats()
       }
    }

    // MARK: - Main Content

    private var mainContent: some View {
        VStack(spacing: 24) {
            Spacer()
            Spacer()
            greetingSection

            // 이번 주 통계
            SectionView(
                title: "이번 주 통계",
                showsButton: true,
                contentHeight: 250,
                isEmpty: statsViewModel.weeklyRecords.isEmpty,
                emptyMessage: "이번 주 학습 기록이 아직 없어요!",
                buttonAction: {
                    isPresentingSubjectManageSheet = true
                }
            ) {
                ForEach(statsViewModel.weeklyRecords) { record in
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
            .frame(maxWidth: .infinity)
            .sheet(isPresented: $isPresentingSubjectManageSheet) {
                SubjectManageView(viewModel: subjectViewModel)
            }
            Spacer()
            // 이번 달 학습량 요약
            if let summary = statsViewModel.monthlySummary {
                MonthlySummarySectionView(
                    daysStudied: summary.studyDay,
                    totalMinutes: summary.studyTime / 60,
                    averageMinutes: summary.averageStudyTime.asMinutesDouble,
                    bestDay: summary.maxStudyDay.dayOnly,
                    bestDayMinutes: summary.maxStudyTime / 60
                )
            } else {
                MonthlySummarySectionView(
                    daysStudied: 0,
                    totalMinutes: 0,
                    averageMinutes: 0,
                    bestDay: "-",
                    bestDayMinutes: 0
                )
            }
            startButton
            Spacer()
            Spacer()
        }
        .padding()
        .disabled(isPresentingStartModal)
        .blur(radius: isPresentingStartModal ? 3 : 0)
        .fullScreenCover(isPresented: $isStudyingModeActive) {
            TimerStudyView(
                onEnd: {
                    isStudyingModeActive = false
                    timerViewModel.stopStudy()
                    if let subject = timerViewModel.selectedSubject {
                        statsViewModel.completeStudy(
                            subjectName: subject.name,
                            elapsedSeconds: timerViewModel.elapsedSeconds
                        )
                    }
                },
                viewModel: timerViewModel,
                subjectViewModel: subjectViewModel
            )
            .environmentObject(statsViewModel)
        }
    }

    // MARK: - Greeting

    private var greetingSection: some View {
        HStack(spacing: 4) {
            Text("루디")
                .font(.PretendardExtraBold24)
                .underline()
                .foregroundStyle(Color.black)

            Text("님 오늘도 공부를 시작해볼까요?")
                .font(.PretendardBold16)
                .foregroundStyle(Color.black)
                .padding(.top, 10)
        }
    }

    // MARK: - Start Button

    private var startButton: some View {
        Button(action: {
            isPresentingStartModal = true
        }) {
            Text("학습 기록 시작")
                .font(.PretendardBold20)
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
                timerViewModel.startStudy()
                isStudyingModeActive = true
            },
            onCancel: {
                isPresentingStartModal = false
            },
            timerViewModel: timerViewModel,
            subjectViewModel: subjectViewModel
        )
    }
}
