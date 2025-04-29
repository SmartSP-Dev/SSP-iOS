//
//  MockQuizData.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/29/25.
//

import Foundation

enum MockQuizData {
    static let sampleQuestions: [QuizQuestion] = [
        QuizQuestion(
            title: "CPU는 중앙처리장치이다.",
            type: .ox,
            options: [],
            answer: "O"
        ),
        QuizQuestion(
            title: "다음 중 CPU 구성 요소가 아닌 것은?",
            type: .multipleChoice,
            options: ["ALU", "CU", "RAM", "레지스터"],
            answer: "RAM"
        ),
        QuizQuestion(
            title: "CPU의 주 기능은 ___의 수행이다.",
            type: .fillInTheBlank,
            options: [],
            answer: "명령어"
        )
    ]
}
