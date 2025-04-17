//
//  Date+Extension.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/15/25.
//

import Foundation

extension Date {
    var onlyDate: Date {
        Calendar.current.startOfDay(for: self)
    }
    func formattedFullDateKorean() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월 d일 (E)"
        return formatter.string(from: self)
    }

    func formattedTime() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "a h시 m분"
        return formatter.string(from: self)
    }
    func isSameDay(as other: Date) -> Bool {
        Calendar.current.isDate(self, inSameDayAs: other)
    }

    func isSameOrBefore(_ other: Date) -> Bool {
        self < other || isSameDay(as: other)
    }
    
}
