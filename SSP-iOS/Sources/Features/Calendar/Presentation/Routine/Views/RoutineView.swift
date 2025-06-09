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
    @State private var isPresentingStatsSheet = false
    
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

                ProgressView(value: viewModel.completionRatio)
                    .progressViewStyle(LinearProgressViewStyle(tint: .black.opacity(0.7)))

                Text("달성도 \(Int(viewModel.completionRatio * 100))%")
                    .font(.headline)
            }
            .padding(.horizontal)
            .padding(.bottom, 12)

            Divider()

            // 3. 루틴 리스트
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.routines) { routine in
                        RoutineCardView(
                            routine: routine,
                            toggleAction: {
                                await viewModel.toggleCheck(for: routine)
                            }
                        )
                    }

                    if viewModel.routines.isEmpty {
                        Text("루틴이 없습니다. 추가해보세요!")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding()
                    }
                }
                .padding(.top, 12)
                .padding(.horizontal)
                .padding(.bottom, 80) // 플로팅 버튼 영역 확보
            }
        }
        .overlay(
            VStack {
                // 통계 버튼
                Button(action: {
                    viewModel.fetchSummary()
                    isPresentingStatsSheet = true
                }) {
                    Image(systemName: "chart.bar.fill")
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(width: 48, height: 48)
                        .background(Color.black.opacity(0.7))
                        .clipShape(Circle())
                        .shadow(radius: 4)
                }
                .padding(.bottom, 12)

                // 기존 루틴 추가 버튼
                Button(action: {
                    isPresentingAddSheet = true
                }) {
                    Image(systemName: "plus")
                        .font(.title)
                        .foregroundColor(.white)
                        .frame(width: 56, height: 56)
                        .background(Color.black.opacity(0.7))
                        .clipShape(Circle())
                        .shadow(radius: 4)
                }
            }
            .padding(),
            alignment: .bottomTrailing
        )
        .sheet(isPresented: $isPresentingAddSheet) {
            RoutineAddView(viewModel: viewModel)
        }
        .sheet(isPresented: $isPresentingStatsSheet) {
            RoutineStatisticsSheetView(summaryList: viewModel.summaryList)
        }
        .onChange(of: viewModel.selectedDate) {
            Task {
                await viewModel.fetchRoutines(for: viewModel.selectedDate)
            }
        }
    }
}

//#Preview {
//    RoutineView(viewModel: RoutineViewModel(repository: MockRoutineRepository()))
//}
