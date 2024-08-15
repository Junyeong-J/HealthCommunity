//
//  LSLPRouter.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/15/24.
//

import Foundation
import Alamofire

enum LSLPRouter {
    
    case SignUpAPI(email: String, password: String, nick: String)

}

extension LSLPRouter: TargetType {
    
    var baseURL: String{
        return APIURL.baseURL
    }
    
    var path: String {
        switch self {
        case .SignUpAPI:
            return APIURL.signUpURL
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .SignUpAPI:
            return .post
        }
    }
    
    var header: [String : String] {
        switch self {
        case .SignUpAPI(let email, let password, let nick):
            return [
                Header.contentType.rawValue: Header.json.rawValue,
                Header.sesacKey.rawValue: APIKey.key
            ]
        }
    }
    
    var parameters: Alamofire.Parameters? {
        return nil
    }
    
    var queryItems: [URLQueryItem]? {
        return nil
    }
    
    var body: Data? {
        return nil
    }

}
