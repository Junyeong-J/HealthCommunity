//
//  PaymentRouter.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/31/24.
//

import Foundation
import Alamofire

enum PaymentRouter: TargetType {
    
    case payment(impID: String, postID: String)
    case myPayment
    
}

extension PaymentRouter {
    
    var baseURL: String {
        return APIURL.baseURL
    }
    
    var path: String {
        switch self {
        case .payment:
            return APIURL.payment
        case .myPayment:
            return APIURL.myPayment
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .payment:
            return .post
        case .myPayment:
            return .get
        }
    }
    
    var header: [String: String] {
        switch self {
        case .payment, .myPayment:
            return [
                Header.sesacKey.rawValue: APIKey.key,
                Header.contentType.rawValue: Header.json.rawValue,
                Header.authorization.rawValue: UserDefaultsManager.shared.token
            ]
        }
    }
    
    var parameters: Parameters? {
        return nil
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .payment, .myPayment:
            return nil
        }
    }
    
    var body: Data? {
        switch self {
        case .payment(let impID, let postID):
            let params: [String: Any] = [
                Body.postid.rawValue: postID,
                Body.imp.rawValue: impID
            ]
            return try? JSONSerialization.data(withJSONObject: params, options: [])
        case .myPayment:
            return nil
        }
    }

}
