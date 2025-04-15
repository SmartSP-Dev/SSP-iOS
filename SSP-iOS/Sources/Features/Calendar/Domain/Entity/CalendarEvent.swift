//
//  CalendarEvent.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/15/25.
//

import Foundation
import SwiftUICore

struct CalendarEvent: Identifiable {
    let id: UUID
    let date: Date
    let title: String
    let color: Color
}
