//
//  MockQuizData.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/29/25.
//

import Foundation

enum MockQuizData {
    static let sampleQuestions: [QuizQuestion] = [
        // 예시 문제들 
        QuizQuestion(
            title: "컴퓨터의 주기억장치는 데이터를 영구적으로 저장한다.",
            type: .ox,
            options: [],
            answer: "X"
        ),
        QuizQuestion(
            title: "다음 중 보조기억장치에 해당하는 것은?",
            type: .multipleChoice,
            options: ["RAM", "ROM", "SSD", "캐시 메모리"],
            answer: "SSD"
        ),
        QuizQuestion(
            title: "연산 및 제어를 수행하는 장치를 ___라고 한다.",
            type: .fillInTheBlank,
            options: [],
            answer: "CPU"
        ),
        QuizQuestion(
            title: "다음 중 입력 장치가 아닌 것은?",
            type: .multipleChoice,
            options: ["키보드", "마우스", "프린터", "스캐너"],
            answer: "프린터"
        ),
        QuizQuestion(
            title: "운영체제는 하드웨어와 사용자 간의 ___ 역할을 한다.",
            type: .fillInTheBlank,
            options: [],
            answer: "중재자"
        ),
        QuizQuestion(
            title: "다음 중 운영체제의 주요 기능이 아닌 것은?",
            type: .multipleChoice,
            options: ["프로세스 관리", "메모리 관리", "네트워크 구축", "파일 시스템 관리"],
            answer: "네트워크 구축"
        ),
        QuizQuestion(
            title: "RAM은 전원이 꺼지면 저장된 데이터가 유지된다.",
            type: .ox,
            options: [],
            answer: "X"
        ),
        QuizQuestion(
            title: "ROM은 ___만 가능하고, 일반적으로 부팅에 필요한 정보를 저장한다.",
            type: .fillInTheBlank,
            options: [],
            answer: "읽기"
        )
    ]
}
