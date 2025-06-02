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
    
    func weekBounds() -> (startOfWeek: Date, endOfWeek: Date) {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: self)
        let startOffset = -(weekday - 2)
        let startOfWeek = calendar.date(byAdding: .day, value: startOffset, to: self)!
        let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek)!
        return (startOfWeek, endOfWeek)
    }
    
    func toDayOfWeekString() -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "E"
            formatter.locale = Locale(identifier: "en_US_POSIX")

            let weekday = formatter.string(from: self).uppercased()
            switch weekday {
            case "SUN": return "SUN"
            case "MON": return "MON"
            case "TUE": return "TUE"
            case "WED": return "WED"
            case "THU": return "THU"
            case "FRI": return "FRI"
            case "SAT": return "SAT"
            default: return "MON"
            }
        }
}

extension Int {
    var asMinutesString: String {
        "\(self / 60)분"
    }

    var asMinutesDouble: Double {
        Double(self) / 60.0
    }

    var asRoundedMinutesString: String {
        String(format: "%.1f분", Double(self) / 60.0)
    }
}

extension String {
    var dayOnly: String {
        let components = self.split(separator: "-")
        return components.count == 3 ? String(components[2]) : "-"
    }
}

extension Date {
    func getDateOfWeek(dayOfWeek: String) -> Date? {
        let calendar = Calendar(identifier: .gregorian)

        // 현재 self가 속한 주의 시작일 (주의: 이건 기본적으로 일요일)
        guard let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else {
            return nil
        }

        let weekdayMap: [String: Int] = [
            "SUN": 0,
            "MON": 1,
            "TUE": 2,
            "WED": 3,
            "THU": 4,
            "FRI": 5,
            "SAT": 6
        ]

        guard let offset = weekdayMap[dayOfWeek.uppercased()] else {
            return nil
        }

        return calendar.date(byAdding: .day, value: offset, to: startOfWeek)
    }

    private static func dayOfWeekIndex(for day: String) -> Int? {
        let days = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
        return days.firstIndex(of: day).map { $0 + 1 }  // Sunday = 1 in iOS
    }
    
    func startOfWeek(using calendar: Calendar = Calendar(identifier: .gregorian)) -> Date {
        var calendarMonday = calendar
        calendarMonday.firstWeekday = 2  // 월요일을 주 시작일로 강제
        let components = calendarMonday.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        return calendarMonday.date(from: components)!
    }
}
