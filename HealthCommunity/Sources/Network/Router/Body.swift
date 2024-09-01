//
//  Body.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/16/24.
//

import Foundation

enum Body: String {
    case email = "email"
    case password = "password"
    case nick = "nick"
    
    case intro = "phoneNum"
    case measure = "birthDay"
    
    case content = "content"
    
    case title = "title"
    case price = "price"
    case content1 = "content1"
    case content2 = "content2"
    case content3 = "content3"
    case content4 = "content4"
    case content5 = "content5"
    
    case productID = "product_id"
    case files = "files"
    
    case imp = "imp_uid"
    case postid = "post_id"
    
    case like = "like_status"
}


enum QueryItems: String {
    case next = "next"
    case limit = "limit"
    case productId = "product_id"
}
