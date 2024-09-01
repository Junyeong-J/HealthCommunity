//
//  PaymentResponse.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/31/24.
//

import Foundation

struct PaymentResponse: Decodable {
    let buyerID: String
    let postID: String
    let merchantUID: String
    let productName: String
    let price: Int
    let paidAt: String
    
    enum CodingKeys: String, CodingKey {
        case buyerID = "buyer_id"
        case postID = "post_id"
        case merchantUID = "merchant_uid"
        case productName = "productName"
        case price
        case paidAt = "paidAt"
    }
}

struct myPaymentResponse: Decodable {
    let data: [PaymentResponse]
}
