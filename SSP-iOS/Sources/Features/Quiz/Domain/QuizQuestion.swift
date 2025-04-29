//
//  QuizQuestion.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/29/25.
//

import Foundation
import SwiftUI

struct QuizQuestion: Identifiable {
    let id = UUID()
    let title: String           // 문제 내용
    let type: QuizType          // 문제 유형: 객관식, OX, 빈칸
    let options: [String]       // 객관식일 경우 보기 목록 (OX는 무시, 빈칸은 빈 배열)
    let answer: String          // 정답
}

extension QuizQuestion {
    static let empty = QuizQuestion(title: "", type: .ox, options: [], answer: "")
}
