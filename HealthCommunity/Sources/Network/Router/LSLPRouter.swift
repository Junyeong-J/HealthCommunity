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
    case EmailCheck(email: String)
    case LoginAPI(email: String, password: String)
    
}

extension LSLPRouter: TargetType {
    
    var baseURL: String{
        return APIURL.baseURL
    }
    
    var path: String {
        switch self {
        case .SignUpAPI:
            return APIURL.signUpURL
        case .EmailCheck:
            return APIURL.emailCheckURL
        case .LoginAPI:
            return APIURL.loginURL
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .SignUpAPI, .EmailCheck, .LoginAPI:
            return .post
        }
    }
    
    var header: [String : String] {
        switch self {
        case .SignUpAPI, .EmailCheck, .LoginAPI:
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
        switch self {
        case .SignUpAPI(let email, let password, let nick):
            return nil
        case .EmailCheck(let email):
            let params: [String: Any] = [
                Body.email.rawValue: email
            ]
            return try? JSONSerialization.data(withJSONObject: params, options: [])
        case .LoginAPI(let email, let password):
            let params: [String: Any] = [
                Body.email.rawValue: email,
                Body.password.rawValue: password
            ]
            return try? JSONSerialization.data(withJSONObject: params, options: [])
        }
    }
    
}
