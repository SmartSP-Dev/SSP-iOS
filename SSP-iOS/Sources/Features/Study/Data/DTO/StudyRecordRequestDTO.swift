//
//  StudyRecordRequestDTO.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/14/25.
//

import Foundation

struct StudyRecordRequestDTO: Encodable {
    let studyId: Int
    let date: String   // yyyy-MM-dd
    let time: Int      // 초 단위
}
