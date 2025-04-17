//
//  CalendarView.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/14/25.
//

//import SwiftUI
//import EventKit
//
///// 월간 달력을 보여주는 뷰
///// - 상단: 월 전환 버튼
///// - 중간: 요일 헤더
///// - 하단: 날짜 셀 그리드 (주 단위)
//struct CalendarView: View {
//
//    // ViewModel 주입 (DIContainer 사용 권장)
//    @ObservedObject var viewModel: CalendarViewModel
//    
//    @State private var showEventEditor = false
//    @GestureState private var dragOffset: CGFloat = 0
//
//
//    // 요일 기호 (일, 월, 화, ...)
//    let weekdaySymbols = Calendar.current.shortStandaloneWeekdaySymbols
//
//    var body: some View {
//        ScrollView {
//            VStack(spacing: 15) {
//                monthHeader            // 상단 월 전환 헤더
//                weekdayHeader          // 요일 헤더
//                dayGrid                // 날짜 셀 그리드
//
//                // 👇 여기에 선택된 날짜의 일정 리스트 추가
//                if let selectedDate = viewModel.selectedDate {
//                    eventList(for: selectedDate)
//                }
//
//                Spacer(minLength: 40)
//            }
//            .padding(.top, 16)
//        }
//        .gesture(
//            DragGesture()
//                .updating($dragOffset) { value, state, _ in
//                    state = value.translation.width
//                }
//                .onEnded { value in
//                    let threshold: CGFloat = 30
//                    withAnimation(.easeInOut) {
//                        if value.translation.width < -threshold {
//                            viewModel.changeMonth(by: 1)
//                        } else if value.translation.width > threshold {
//                            viewModel.changeMonth(by: -1)
//                        }
//                    }
//                }
//        )
//    }
//    
//    @ViewBuilder
//    private func eventList(for date: Date) -> some View {
//        let events = viewModel.events[date.onlyDate] ?? []
//
//        VStack(alignment: .leading, spacing: 8) {
//            Text("선택된 날짜의 일정")
//                .font(.headline)
//                .padding(.horizontal)
//
//            if events.isEmpty {
//                Text("등록된 일정이 없습니다.")
//                    .foregroundColor(.gray)
//                    .padding(.horizontal)
//            } else {
//                ForEach(events, id: \.id) { event in
//                    HStack {
//                        RoundedRectangle(cornerRadius: 4)
//                            .fill(event.color)
//                            .frame(width: 8, height: 8)
//
//                        Text(event.title)
//                            .font(.body)
//                            .foregroundColor(.primary)
//
//                        Spacer()
//                    }
//                    .padding(.horizontal)
//                }
//            }
//        }
//        .padding(.top, 10)
//    }
//
//
//
//    // MARK: - 월 전환 헤더
//    private var monthHeader: some View {
//        HStack {
//            // 왼쪽: 월 텍스트
//            Text(viewModel.currentMonth, formatter: monthOnlyFormatter)
//                .font(.title2)
//                .fontWeight(.bold)
//                .foregroundStyle(Color("mainColor800"))
//
//            Spacer()
//
//            // 오른쪽: 일정 추가 버튼
//            Button(action: {
//                let store = EKEventStore()
//                store.requestFullAccessToEvents { granted, _ in
//                    if granted {
//                        DispatchQueue.main.async {
//                            showEventEditor = true
//                        }
//                    }
//                }
//            }) {
//                Image(systemName: "plus.circle")
//                    .font(.title2)
//                    .foregroundStyle(Color("mainColor800"))
//            }
//            .sheet(isPresented: $showEventEditor) {
//                EventEditView(startDate: viewModel.selectedDate ?? Date())
//            }
//
//        }
//        .padding(.horizontal, 16)
//    }
//
//    // MARK: - 요일 헤더 (일, 월, ...)
//    private var weekdayHeader: some View {
//        HStack(spacing: 4) {
//            ForEach(weekdaySymbols, id: \.self) { symbol in
//                Text(symbol)
//                    .font(.PretendardSemiBold16)
//                    .frame(maxWidth: .infinity)
//                    .foregroundStyle(Color("mainColor800"))
//            }
//        }
//        .padding(.horizontal, 2)
//    }
//
//    // MARK: - 날짜 셀 그리드 (주 단위로 렌더링)
//    private var dayGrid: some View {
//        LazyVStack(spacing: 0) {
//            ForEach(0..<viewModel.daysInMonth.chunked(into: 7).count, id: \.self) { weekIndex in
//                let week = viewModel.daysInMonth.chunked(into: 7)[weekIndex]
//                
//                HStack(spacing: 2) {
//                    ForEach(0..<week.count, id: \.self) { dayIndex in
//                        let date = week[dayIndex]
//                        
//                        if Calendar.current.isDate(date, equalTo: Date.distantPast, toGranularity: .day) {
//                            // 빈 칸 (해당 주에 날짜가 없는 셀)
//                            Color.clear.frame(height: 80).frame(maxWidth: .infinity)
//                        } else {
//                            // 정상 날짜 셀
//                            CalendarDayCellView(
//                                date: date,
//                                events: viewModel.events[date.onlyDate] ?? [],
//                                isToday: Calendar.current.isDateInToday(date),
//                                isSelected: viewModel.selectedDate == date
//                            )
//                            .onTapGesture {
//                                viewModel.selectedDate = date
//                            }
//                            .frame(maxWidth: .infinity)
//                        }
//                    }
//                }
//                .padding(.horizontal, 4)
//
//                // 주 구분선
//                Rectangle()
//                    .fill(Color.black.opacity(0.15))
//                    .frame(height: 1)
//                    .padding(.horizontal, 4)
//            }
//        }
//    }
//
//    // MARK: - 월 텍스트 포맷터 ("2025년 4월")
//    private var monthOnlyFormatter: DateFormatter {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "M월"
//        return formatter
//    }
//}
//
//// MARK: - Array chunking (주 단위로 나누기)
//extension Array {
//    /// 배열을 지정된 크기로 분할하여 2차원 배열로 리턴
//    func chunked(into size: Int) -> [[Element]] {
//        stride(from: 0, to: count, by: size).map {
//            Array(self[$0..<Swift.min($0 + size, count)])
//        }
//    }
//}
//
