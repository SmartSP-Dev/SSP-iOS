//
//  Route.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/22/25.
//

import Foundation

enum Route: Hashable {
    case quizList
    case quizDetail(id: String)
    case quizCreate
    case study
    case calendar
    case login
}
