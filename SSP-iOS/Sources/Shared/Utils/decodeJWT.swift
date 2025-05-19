//
//  decodeJWT.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/19/25.
//

import Foundation

struct JWTPayload: Decodable {
    let exp: TimeInterval
    let iat: TimeInterval
    let sub: String
}

enum JWTDecoder {
    static func decode(token: String) -> JWTPayload? {
        let segments = token.components(separatedBy: ".")
        guard segments.count == 3 else { return nil }
        
        let payloadSegment = segments[1]
        var base64 = payloadSegment
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "-", with: "/")
        
        while base64.count % 4 != 0 {
            base64 += "="
        }
        
        guard let payloadData = Data(base64Encoded: base64),
              let payload = try? JSONDecoder().decode(JWTPayload.self, from: payloadData) else {
            return nil
        }
        
        return payload
    }
    
    static func isExpired(token: String) -> Bool {
        guard let payload = decode(token: token) else {
            return true 
        }
        
        return payload.exp <= Date().timeIntervalSince1970
    }
}
