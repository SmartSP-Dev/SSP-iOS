//
//  GroupAPI.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/20/25.
//

import Foundation
import Moya

enum GroupAPI {
    case createGroup(startDate: String, endDate: String, groupName: String)
    case fetchMyGroups
    case fetchGroupMembers(groupKey: String)
    case fetchGroupTimetable(groupKey: String)
    case joinGroup(groupKey: String)
    case fetchUserSchedule(groupKey: String)
    case saveUserSchedule(groupKey: String, timeBlocks: [UserTimeBlockDTO])
    case getWeightAndMembers(groupKey: String, dayOfWeek: String, time: String)
}


extension GroupAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://leeyj.xyz")!
    }
    
    var path: String {
        switch self {
        case .createGroup:
            return "/when2meet/groups"
        case .fetchMyGroups:
            return "/when2meet/users/groups"
        case .fetchGroupMembers(let groupKey):
            return "/when2meet/groups/\(groupKey)/members"
        case .fetchGroupTimetable(let groupKey):
            return "/when2meet/groups/\(groupKey)/timetable"
        case .joinGroup(let groupKey):
            return "/when2meet/groups/\(groupKey)/members"
        case .fetchUserSchedule(let groupKey):
            return "/when2meet/groups/\(groupKey)/usertimeblock"
        case .saveUserSchedule(let groupKey, _):
            return "/when2meet/groups/\(groupKey)/timetable"
        case let .getWeightAndMembers(groupKey, _, _):
            return "/when2meet/groups/\(groupKey)/timetable/weightAndMembers"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createGroup, .joinGroup, .saveUserSchedule, .getWeightAndMembers:
            return .post
        case .fetchMyGroups, .fetchGroupMembers, .fetchGroupTimetable, .fetchUserSchedule:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case let .createGroup(startDate, endDate, groupName):
            let parameters: [String: Any] = [
                "startDate": startDate,
                "endDate": endDate,
                "groupName": groupName
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .fetchMyGroups, .fetchGroupMembers, .fetchGroupTimetable, .joinGroup:
            return .requestPlain
        case .fetchUserSchedule:
            return .requestPlain
        case let .saveUserSchedule(_, timeBlocks):
            return .requestJSONEncodable(["timeBlocks": timeBlocks])
        case let .getWeightAndMembers(_, dayOfWeek, time):
            return .requestParameters(
                parameters: ["dayOfWeek": dayOfWeek, "time": time],
                encoding: JSONEncoding.default
            )
        }
    }
    
    var headers: [String : String]? {
        var headers = ["Content-Type": "application/json"]
        if let token = KeychainManager.shared.accessToken, !token.isEmpty {
            headers["Authorization"] = "Bearer \(token)"
        }
        return headers
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
    
    var sampleData: Data {
        return Data()
    }
    
}
