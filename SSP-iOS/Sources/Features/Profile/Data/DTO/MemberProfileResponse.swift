//
//  MemberProfileResponse.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/28/25.
//

import Foundation

struct MemberProfileResponse: Codable {
    let userId: Int
    let email: String
    let name: String
    let university: String
    let department: String
    let profileImage: String
    let everytimeUrl: String
    let provider: String
}
