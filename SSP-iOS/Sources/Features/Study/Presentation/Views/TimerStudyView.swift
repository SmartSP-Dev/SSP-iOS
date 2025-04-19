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

    var body: some View {
        VStack(spacing: 40) {
            Spacer()

            Text("학습 시간")
                .font(.title)
            Text(viewModel.elapsedSeconds.formattedTimeString())
                .font(.system(size: 48, weight: .bold))

            HStack(spacing: 30) {
                Button("종료") {
                    onEnd()
                }
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .clipShape(Capsule())

                Button("일시정지") {
                    // 필요하면 여기 pause 구현
                }
                .padding()
                .background(Color.gray)
                .foregroundColor(.white)
                .clipShape(Capsule())
            }

            Spacer()

            Text("버튼을 꼭 누를 경우 학습 모드가 종료됩니다.")
                .font(.footnote)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .ignoresSafeArea()
    }
}

private extension Int {
    func formattedTimeString() -> String {
        String(format: "%02d : %02d", self / 60, self % 60)
    }
}

#Preview("⏱️ 학습 타이머 화면") {
    let viewModel = StudyTimerViewModel()
    viewModel.elapsedSeconds = 153 // 예시: 02분 33초

    return TimerStudyView(
        onEnd: {},
        viewModel: viewModel
    )
}
