//
//  Route.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/22/25.
//

import Foundation

enum Route: Hashable {
    case study
    case calendar
    case login
    case groupHome
    case quizSolve(quizId: Int)
    case quizResult(quizId: Int)
    case groupSchedule(group: ScheduleGroup)
    case groupAvailability(group: ScheduleGroup)
    case quizList
    case quizDetail(id: String)
    case quizCreate
}
