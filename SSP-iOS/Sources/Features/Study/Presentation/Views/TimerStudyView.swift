//
//  TimerStudyView.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/17/25.
//

import SwiftUI

struct TimerStudyView: View {
    var onEnd: () -> Void
    @ObservedObject var viewModel: StudyTimerViewModel
    @EnvironmentObject var statisticsViewModel: StatisticsViewModel
    @ObservedObject var subjectViewModel: SubjectManageViewModel


    @State private var pressProgress: Double = 0
    @State private var pressTimer: Timer?

    var body: some View {
        VStack(spacing: 40) {
            Spacer()

            Text("학습 시간")
                .font(.title)
            Text(viewModel.elapsedSeconds.formattedTimeString())
                .font(.system(size: 48, weight: .bold))

            if !viewModel.isPaused {
                Text("")
                    .foregroundColor(.white)
                    .font(.subheadline)
            } else {
                Text("일시 정지 중")
                    .foregroundColor(.red)
                    .font(.subheadline)
            }

            HStack(spacing: 30) {
                Text("종료")
                    .padding()
                    .frame(width: 100)
                    .background(interpolatedColor(from: .black, to: .red, progress: pressProgress))
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                    .onLongPressGesture(minimumDuration: 2.0) {
                        let generator = UIImpactFeedbackGenerator(style: .medium)
                        generator.impactOccurred()
                        
                        if let subject = viewModel.selectedSubject {
                            let studyId = subject.studyId
                            let elapsedTime = viewModel.elapsedSeconds
                            let dateString = DateFormatter.yyyyMMdd.string(from: Date())  // "yyyy-MM-dd"

                            let dto = StudyRecordRequestDTO(studyId: studyId, date: dateString, time: elapsedTime)
                            SubjectRepositoryImpl().uploadRecord(dto) { result in
                                switch result {
                                case .success:
                                    print("공부 기록 업로드 성공")

                                    // 서버 최신 데이터 다시 불러오기
                                    DispatchQueue.main.async {
                                        statisticsViewModel.completeStudy(subjectName: subject.name, elapsedSeconds: elapsedTime)
                                        subjectViewModel.loadSubjectsFromServer()
                                        statisticsViewModel.loadWeeklyStudyFromServer()
                                        statisticsViewModel.loadMonthlyStats()
                                    }

                                case .failure(let error):
                                    print("기록 업로드 실패: \(error)")
                                }
                            }
                        }
                        onEnd()

                    } onPressingChanged: { isPressing in
                        if isPressing {
                            startPressTimer()
                        } else {
                            stopPressTimer()
                        }
                    }

                Button(viewModel.isPaused ? "재개" : "일시정지") {
                    if viewModel.isPaused {
                        viewModel.resume()
                    } else {
                        viewModel.pause()
                    }
                }
                .padding()
                .frame(width: 100)
                .background(Color.gray)
                .foregroundColor(.white)
                .clipShape(Capsule())
            }

            Spacer()

            Text("※ 학습 종료를 원하시면 종료 버튼 꾹 눌러주세요!!")
                .font(.footnote)
                .foregroundColor(.gray)
                .padding(.bottom, 5)
        }
        .padding()
        .background(Color.white)
        .ignoresSafeArea()
    }

    // 색상 보간 함수
    private func interpolatedColor(from: Color, to: Color, progress: Double) -> Color {
        let fromUIColor = UIColor(from)
        let toUIColor = UIColor(to)

        var fromRed: CGFloat = 0, fromGreen: CGFloat = 0, fromBlue: CGFloat = 0, fromAlpha: CGFloat = 0
        var toRed: CGFloat = 0, toGreen: CGFloat = 0, toBlue: CGFloat = 0, toAlpha: CGFloat = 0

        fromUIColor.getRed(&fromRed, green: &fromGreen, blue: &fromBlue, alpha: &fromAlpha)
        toUIColor.getRed(&toRed, green: &toGreen, blue: &toBlue, alpha: &toAlpha)

        let red = fromRed + (toRed - fromRed) * progress
        let green = fromGreen + (toGreen - fromGreen) * progress
        let blue = fromBlue + (toBlue - fromBlue) * progress

        return Color(red: Double(red), green: Double(green), blue: Double(blue))
    }

    private func startPressTimer() {
        pressProgress = 0
        pressTimer?.invalidate()
        pressTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
            if pressProgress < 1 {
                pressProgress += 0.05
            } else {
                pressTimer?.invalidate()
            }
        }
    }

    private func stopPressTimer() {
        pressTimer?.invalidate()
        pressTimer = nil
        pressProgress = 0
    }
}

private extension Int {
    func formattedTimeString() -> String {
        String(format: "%02d : %02d", self / 60, self % 60)
    }
}

extension DateFormatter {
    static let yyyyMMdd: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}

