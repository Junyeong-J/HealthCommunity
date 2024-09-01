//
//  LSLPRouter.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/15/24.
//

import Foundation
import Alamofire

enum LSLPRouter {
    case auth(AuthRouter)
    case post(PostRouter)
    case profile(ProfileRouter)
    case comment(CommentRouter)
    case payment(PaymentRouter)
}

extension LSLPRouter: TargetType {
    
    var baseURL: String {
        switch self {
        case .auth(let router):
            return router.baseURL
        case .post(let router):
            return router.baseURL
        case .profile(let router):
            return router.baseURL
        case .comment(let router):
            return router.baseURL
        case .payment(let router):
            return router.baseURL
        }
    }
    
    var path: String {
        switch self {
        case .auth(let router):
            return router.path
        case .post(let router):
            return router.path
        case .profile(let router):
            return router.path
        case .comment(let router):
            return router.path
        case .payment(let router):
            return router.path
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .auth(let router):
            return router.method
        case .post(let router):
            return router.method
        case .profile(let router):
            return router.method
        case .comment(let router):
            return router.method
        case .payment(let router):
            return router.method
        }
    }
    
    var header: [String: String] {
        switch self {
        case .auth(let router):
            return router.header
        case .post(let router):
            return router.header
        case .profile(let router):
            return router.header
        case .comment(let router):
            return router.header
        case .payment(let router):
            return router.header
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .auth(let router):
            return router.parameters
        case .post(let router):
            return router.parameters
        case .profile(let router):
            return router.parameters
        case .comment(let router):
            return router.parameters
        case .payment(let router):
            return router.parameters
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .auth(let router):
            return router.queryItems
        case .post(let router):
            return router.queryItems
        case .profile(let router):
            return router.queryItems
        case .comment(let router):
            return router.queryItems
        case .payment(let router):
            return router.queryItems
        }
    }
    
    var body: Data? {
        switch self {
        case .auth(let router):
            return router.body
        case .post(let router):
            return router.body
        case .profile(let router):
            return router.body
        case .comment(let router):
            return router.body
        case .payment(let router):
            return router.body
        }
    }
}
