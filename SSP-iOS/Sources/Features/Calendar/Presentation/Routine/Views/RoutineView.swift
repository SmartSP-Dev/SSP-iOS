//
//  RoutineView.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/14/25.
//

import SwiftUI

struct RoutineView: View {
    @StateObject var viewModel: RoutineViewModel
    @State private var isPresentingAddSheet = false

    var body: some View {
        VStack(spacing: 0) {
            // 1. 드래그 가능한 주간 달력
            RoutineCalendarView(viewModel: viewModel)
                .padding(.bottom, 8)

            // 2. 오늘의 루틴 달성도
            VStack(alignment: .leading, spacing: 6) {
                Text("오늘의 루틴 달성도")
                    .font(.caption)
                    .foregroundColor(.gray)

                ProgressView(value: completionRatio)
                    .progressViewStyle(LinearProgressViewStyle(tint: .blue))

                Text("달성도 \(Int(completionRatio * 100))%")
                    .font(.headline)
            }
            .padding(.horizontal)
            .padding(.bottom, 12)

            Divider()

            // 3. 루틴 리스트
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.visibleRoutines) { routine in
                        RoutineCardView(
                            routine: routine,
                            isChecked: viewModel.checkStatesForSelectedDate[routine.id] ?? false
                        ) {
                            viewModel.toggleCheck(for: routine.id)
                        }
                    }

                    // 데모용 예시 루틴 (루틴 없을 경우)
                    if viewModel.visibleRoutines.isEmpty {
                        ForEach(sampleRoutineList) { item in
                            RoutineCardView(routine: item, isChecked: false, toggleAction: {})
                        }
                    }
                }
                .padding(.top, 12)
                .padding(.horizontal)
                .padding(.bottom, 80) // 플로팅 버튼 영역 확보
            }
        }
        .overlay(
            // 4. 플로팅 추가 버튼
            Button(action: {
                isPresentingAddSheet = true
            }) {
                Image(systemName: "plus")
                    .font(.title)
                    .foregroundColor(.white)
                    .frame(width: 56, height: 56)
                    .background(Color.blue)
                    .clipShape(Circle())
                    .shadow(radius: 4)
            }
            .padding(),
            alignment: .bottomTrailing
        )
        .sheet(isPresented: $isPresentingAddSheet) {
            RoutineAddView(viewModel: viewModel)
        }
    }

    // MARK: - 루틴 완료 비율
    private var completionRatio: Double {
        let total = viewModel.visibleRoutines.count
        guard total > 0 else { return 0.0 }
        let checked = viewModel.visibleRoutines.filter { viewModel.checkStates[$0.id] ?? false }.count
        return Double(checked) / Double(total)
    }

    // MARK: - 루틴 예시 (없을 경우 보여줄 카드)
    private let sampleRoutineList: [RoutineItem] = [
        .init(id: UUID(), title: "영어 단어 암기", createdDate: Date()),
        .init(id: UUID(), title: "30분 스트레칭", createdDate: Date()),
        .init(id: UUID(), title: "독서 20쪽", createdDate: Date())
    ]
}

#Preview {
    RoutineView(viewModel: RoutineViewModel(repository: LocalRoutineRepository()))
}
