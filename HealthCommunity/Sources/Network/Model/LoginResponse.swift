//
//  LoginResponse.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/18/24.
//

import Foundation

struct LoginResponse: Decodable {
    let userId: String
    let email: String
    let nick: String
    let accessToken: String
    let refreshToken: String
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email
        case nick
        case accessToken
        case refreshToken
    }
}