//
//  CalendarUseCase.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/15/25.
//

import Foundation

final class CalendarUseCase {
    private let repository: CalendarRepository

    init(repository: CalendarRepository) {
        self.repository = repository
    }

    func getEvents(forMonth date: Date) -> [CalendarEvent] {
        return repository.fetchEvents(forMonth: date)
    }
    
    func requestCalendarAccess(completion: @escaping (Bool) -> Void) {
        repository.requestCalendarAccess(completion: completion)
    }
}
