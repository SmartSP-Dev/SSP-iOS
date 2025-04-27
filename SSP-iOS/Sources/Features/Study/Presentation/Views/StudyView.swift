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
    @StateObject private var subjectViewModel = SubjectManageViewModel()
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
            MonthlySummarySectionView(
                daysStudied: statsViewModel.totalStudyDays,
                totalMinutes: statsViewModel.totalMonthlyMinutes,
                averageMinutes: statsViewModel.averageMinutesPerDay,
                bestDay: statsViewModel.bestStudyDayFormatted,
                bestDayMinutes: statsViewModel.bestStudyDayMinutes
            )
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
                viewModel: timerViewModel
            )
            .environmentObject(statisticsViewModel)
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

#Preview {
    let timerVM = StudyTimerViewModel()
    let subjectVM = SubjectManageViewModel()
    let statsVM = StatisticsViewModel()

    // 예시 과목 추가
    subjectVM.subjects = [
        StudySubject(name: "수학", time: 120),
        StudySubject(name: "영어", time: 90),
        StudySubject(name: "과학", time: 45)
    ]

    // 예시 주간 기록 추가
    statsVM.weeklyRecords = [
        WeeklyStudyRecord(subjectName: "수학", totalMinutes: 120),
        WeeklyStudyRecord(subjectName: "영어", totalMinutes: 60)
    ]

    // 예시 일간 기록 추가
    statsVM.studyRecords = [
        DailyStudyRecord(date: Date().addingTimeInterval(-86400 * 2), subjectName: "수학", minutes: 90),
        DailyStudyRecord(date: Date().addingTimeInterval(-86400), subjectName: "영어", minutes: 60),
        DailyStudyRecord(date: Date(), subjectName: "과학", minutes: 45)
    ]

    return StudyView()
        .environmentObject(timerVM)
        .environmentObject(subjectVM)
        .environmentObject(statsVM)
}
