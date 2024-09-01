//
//  PostResponse.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/23/24.
//

import Foundation

struct PostViewResponse: Decodable {
    let data: [Post]
    let nextCursor: String
    
    enum CodingKeys: String, CodingKey {
        case data
        case nextCursor = "next_cursor"
    }
}

struct Post: Decodable {
    let postID: String
    let productID: String
    let title: String?
    let price: Int?
    let content: String?
    let content1: String?
    let content2: String?
    let content3: String?
    let content4: String?
    let buyers: [String]
    let createdAt: String
    let creator: Creator
    let files: [String]
    let likes: [String]
    let likes2: [String]
    let hashTags: [String]
    let comments: [Comment]
    
    enum CodingKeys: String, CodingKey {
        case postID = "post_id"
        case productID = "product_id"
        case title
        case price
        case content
        case content1
        case content2
        case content3
        case content4
        case buyers
        case createdAt
        case creator
        case files
        case likes
        case likes2
        case hashTags
        case comments
    }
}

struct Comment: Decodable {
    let commentID: String
    let content: String
    let createdAt: String
    let creator: Creator
    
    enum CodingKeys: String, CodingKey {
        case commentID = "comment_id"
        case content
        case createdAt
        case creator
    }
}

struct Creator: Decodable {
    let userID: String
    let nick: String
    let profileImage: String?
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case nick
        case profileImage = "profileImage"
    }
}


struct PostModelResponse: Decodable {
    let postId: String
    let productId: String
    let title: String?
    let price: Int?
    let content: String?
    let content1: String?
    let content2: String?
    let content3: String?
    let content4: String?
    let content5: String?
    let createdAt: String
    let creator: Creator
    let files: [String]
    let likes: [String]
    let likes2: [String]
    let hashTags: [String]
    let comments: [Comment]

    enum CodingKeys: String, CodingKey {
        case postId = "post_id"
        case productId = "product_id"
        case title, price, content, content1, content2, content3, content4, content5
        case createdAt
        case creator
        case files, likes, likes2, hashTags, comments
    }
}

struct likeResponse: Decodable {
    let likeStaus: Bool
    enum CodingKeys: String, CodingKey {
        case likeStaus = "like_status"
    }
}
