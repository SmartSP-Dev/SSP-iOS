//
//  CalendarViewModel.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/15/25.
//

import Foundation
import SwiftUI

/// 월간 달력 화면을 위한 ViewModel (MVVM의 ViewModel 역할)
/// - 현재 월 변경, 선택 날짜 관리, 이벤트 로드 등의 책임을 가짐
final class CalendarViewModel: ObservableObject {
    
    // MARK: - 외부에 바인딩되는 상태
    
    /// 날짜별 일정 목록 (key: Date.onlyDate)
    @Published var events: [Date: [CalendarEvent]] = [:]

    /// 현재 보고 있는 월
    @Published var currentMonth: Date = Date()

    /// 유저가 선택한 날짜
    @Published var selectedDate: Date? = nil

    /// 해당 월에 표시될 날짜 배열 (빈 칸 포함)
    private(set) var daysInMonth: [Date] = []

    // MARK: - 의존성 주입
    let useCase: CalendarUseCase

    // MARK: - 초기화
    init(useCase: CalendarUseCase) {
        self.useCase = useCase
        generateDaysInMonth()
        
        let calendar = Calendar.current
        let now = Date()
        if calendar.isDate(now, equalTo: currentMonth, toGranularity: .month) {
            selectedDate = now
        } else if let firstDay = calendar.date(from: calendar.dateComponents([.year, .month], from: currentMonth)) {
            selectedDate = firstDay
        }

        requestCalendarAccessAndLoadEvents()
    }

    // MARK: - 월 변경 (이전 / 다음)
    func changeMonth(by value: Int) {
        guard let newDate = Calendar.current.date(byAdding: .month, value: value, to: currentMonth) else { return }
        currentMonth = newDate
        generateDaysInMonth()

        // selectedDate 초기화 로직 추가
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: newDate)
        if let firstDayOfMonth = calendar.date(from: components) {
            if calendar.isDate(Date(), equalTo: newDate, toGranularity: .month) {
                selectedDate = Date() // 오늘이 현재 월에 속하면 오늘 선택
            } else {
                selectedDate = firstDayOfMonth // 아니라면 월의 첫 날 선택
            }
        }

        requestCalendarAccessAndLoadEvents()
    }

    // MARK: - 현재 월의 날짜 목록 생성
    /// 달력 셀 배열을 구성하기 위해 날짜 리스트 생성
    /// - 주 단위 정렬을 위해 앞뒤로 빈 칸(Date.distantPast)을 포함
    func generateDaysInMonth() {
        let calendar = Calendar.current
        guard let monthRange = calendar.range(of: .day, in: .month, for: currentMonth),
              let firstDay = calendar.date(from: calendar.dateComponents([.year, .month], from: currentMonth)) else { return }

        let weekday = calendar.component(.weekday, from: firstDay) // 해당 월의 1일이 무슨 요일인지
        let prefixEmptyDays = weekday - 1 // 앞에 비워야 할 셀 개수

        var days: [Date] = []

        // 앞쪽 빈 셀 (달의 시작 요일을 맞추기 위해)
        for _ in 0..<prefixEmptyDays {
            days.append(Date.distantPast)
        }

        // 해당 월의 날짜 셀
        for day in monthRange {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: firstDay) {
                days.append(date)
            }
        }

        // 마지막 줄 빈 셀 채우기 (총 7로 나누어 떨어지게)
        let remaining = 7 - (days.count % 7)
        if remaining < 7 {
            for _ in 0..<remaining {
                days.append(Date.distantPast)
            }
        }

        self.daysInMonth = days
    }

    // MARK: - 일정 로드 (권한 요청 포함)
    /// 캘린더 권한 요청 후, 해당 월의 이벤트 데이터를 불러옴
    func requestCalendarAccessAndLoadEvents() {
        useCase.requestCalendarAccess { [weak self] granted in
            guard let self = self else { return }

            guard granted else {
                print("캘린더 접근 거부됨")
                return
            }

            // 일정 로드 → 날짜별로 그룹핑
            let result = self.useCase.getEvents(forMonth: self.currentMonth)
            DispatchQueue.main.async {
                self.events = Dictionary(grouping: result, by: { $0.date.onlyDate })
            }
        }
    }
}
