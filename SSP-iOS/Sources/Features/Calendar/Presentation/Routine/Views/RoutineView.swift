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
        VStack(alignment: .leading, spacing: 12) {
            // MARK: - 1. 상단 주간 캘린더 뷰
            RoutineCalendarView(viewModel: viewModel)

            // MARK: - 2. 달성도 + 버튼
            HStack {
                Text("달성도 60%") // 추후 계산 로직 반영
                    .font(.headline)

                Spacer()

                Button(action: {
                    // 통계 기능 아직 없음
                }) {
                    Image(systemName: "chart.bar")
                        .font(.title2)
                }

                Button(action: {
                    isPresentingAddSheet = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                }
            }
            .padding(.horizontal)

            // MARK: - 3. 루틴 리스트
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(viewModel.visibleRoutines) { routine in
                        let isChecked = viewModel.checkStatesForSelectedDate[routine.id] ?? false

                        HStack {
                            Image(systemName: isChecked ? "checkmark.circle.fill" : "circle")
                                .onTapGesture {
                                    viewModel.toggleCheck(for: routine.id)
                                }

                            Text(routine.title)
                            Spacer()
                        }
                    }
                }
                .padding(.top, 8)
            }
        }
        .sheet(isPresented: $isPresentingAddSheet) {
            RoutineAddView(viewModel: viewModel)
        }
    }
}


//#Preview {
//    let dummyRepo = DummyRoutineRepository()
//    let viewModel = RoutineViewModel(repository: dummyRepo)
//    RoutineView(viewModel: viewModel)
//}
