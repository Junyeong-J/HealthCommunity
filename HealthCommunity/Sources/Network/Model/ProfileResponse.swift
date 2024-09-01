//
//  ProfileResponse.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/24/24.
//

import Foundation

struct UserProfile: Decodable {
    let userId: String
    let email: String
    let nick: String
    let phoneNum: String?
    let birthDay: String?
    let profileImage: String?
    let followers: [Follower]
    let following: [Follower]
    let posts: [String]

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email
        case nick
        case phoneNum
        case birthDay
        case profileImage
        case followers
        case following
        case posts
    }
}

struct Follower: Decodable {
    let userId: String
    let nick: String
    let profileImage: String

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case nick
        case profileImage
    }
}

