//
//  CalendarRepository.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/15/25.
//

import Foundation

protocol CalendarRepository {
    func fetchEvents(forMonth date: Date) -> [CalendarEvent]
    func requestCalendarAccess(completion: @escaping (Bool) -> Void)
}
