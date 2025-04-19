//
//  StudySubject.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/17/25.
//

import Foundation

struct StudySubject: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String
    var time: Int // 분 단위로 저장
}
