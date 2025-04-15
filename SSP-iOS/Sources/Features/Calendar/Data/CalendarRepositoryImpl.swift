//
//  CalendarRepositoryImpl.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/15/25.
//

import Foundation

/// CalendarRepository 프로토콜을 따르는 실제 구현체
/// CalendarEventFetcher를 내부에 포함하며, 시스템 캘린더에서 이벤트 데이터를 가져온다.
final class CalendarRepositoryImpl: CalendarRepository {
    /// EventKit 접근을 전담하는 fetcher 인스턴스
    private let fetcher = CalendarEventFetcher()

    /// 특정 월의 이벤트들을 가져옴
    /// - Parameter date: 기준이 되는 월
    /// - Returns: CalendarEvent 배열
    func fetchEvents(forMonth date: Date) -> [CalendarEvent] {
        return fetcher.fetchEvents(forMonth: date)
    }

    /// 캘린더 접근 권한 요청 메서드
    /// ViewModel → UseCase → Repository 구조에서 요청 흐름 연결을 위한 메서드
    func requestCalendarAccess(completion: @escaping (Bool) -> Void) {
        fetcher.requestAccess(completion: completion)
    }
}
