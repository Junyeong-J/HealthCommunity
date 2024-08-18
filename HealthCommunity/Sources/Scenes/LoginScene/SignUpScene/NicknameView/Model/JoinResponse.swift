//
//  JoinResponse.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/18/24.
//

import Foundation

struct JoinResponse: Decodable {
    let userId: String
    let email: String
    let nick: String
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email
        case nick
    }
}
