//
//  CalendarEventFetcher.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/15/25.
//

import EventKit
import Foundation
import SwiftUI

/// 시스템 기본 캘린더 앱의 이벤트 데이터를 가져오는 클래스
/// EventKit 프레임워크를 통해 사용자의 캘린더에 접근
final class CalendarEventFetcher {
    /// 이벤트를 관리하는 시스템 저장소 인스턴스 (EventKit의 핵심 객체)
    private let store = EKEventStore()

    /// 시스템 캘린더 접근 권한 요청
    /// iOS 17 이상에서는 requestAccess가 deprecated 되었으므로 requestFullAccessToEvents 사용
    /// - Parameter completion: 사용자 응답 결과(true/false)를 비동기로 반환
    func requestAccess(completion: @escaping (Bool) -> Void) {
        store.requestFullAccessToEvents { granted, _ in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }

    /// 해당 월의 캘린더 이벤트들을 가져오는 메서드
    /// - Parameter date: 월 기준 날짜
    /// - Returns: CalendarEvent 배열 (id, 시작 날짜, 타이틀, 색상 포함)
    func fetchEvents(forMonth date: Date) -> [CalendarEvent] {
        let calendar = Calendar.current

        // 해당 월의 시작 날짜 계산 (예: 2024-04-01)
        guard let start = calendar.date(from: calendar.dateComponents([.year, .month], from: date)),
              let end = calendar.date(byAdding: .month, value: 1, to: start) else {
            return []
        }

        // 시작~종료 날짜 범위 내 이벤트 필터 생성
        let predicate = store.predicateForEvents(withStart: start, end: end, calendars: nil)

        // 조건에 맞는 모든 이벤트 배열 반환
        let events = store.events(matching: predicate)

        // CalendarEvent 모델로 변환 후 반환
        return events.map {
            CalendarEvent(
                id: UUID(),
                date: $0.startDate,
                title: $0.title,
                color: Color("mainColor800"),
                startDate: $0.startDate,
                endDate: $0.endDate,
                isAllDay: $0.isAllDay,
                ekEventID: $0.eventIdentifier
            )
        }
    }
}
