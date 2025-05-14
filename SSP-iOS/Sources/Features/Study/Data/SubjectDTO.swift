//
//  SubjectDTO.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/14/25.
//

import Foundation

struct SubjectDTO: Decodable {
    let studyId: Int
    let subject: String
    let totalStudyTime: Int?
}
