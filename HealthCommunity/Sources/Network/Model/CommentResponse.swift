//
//  CommentResponse.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/25/24.
//

import Foundation

struct CommentPost: Codable {
    let commentID: String
    let content: String
    let createdAt: String
    let creator: CommentCreator

    enum CodingKeys: String, CodingKey {
        case commentID = "commnet_id"
        case content
        case createdAt = "createdAt"
        case creator
    }
}

struct CommentCreator: Codable {
    let userID: String
    let nick: String
    let profileImage: String?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case nick
        case profileImage
    }
}
