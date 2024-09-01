//
//  LikeResponse.swift
//  HealthCommunity
//
//  Created by 전준영 on 9/1/24.
//

import Foundation

struct MeLikeResponse: Decodable {
    let data: [Post]
    let nextCursor: String?
    
    enum CodingKeys: String, CodingKey {
        case data
        case nextCursor = "next_cursor"
    }
}
