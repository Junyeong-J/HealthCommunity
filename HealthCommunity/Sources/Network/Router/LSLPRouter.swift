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
}

extension LSLPRouter: TargetType {
    
    var baseURL: String {
        switch self {
        case .auth(let router):
            return router.baseURL
        case .post(let router):
            return router.baseURL
        }
    }
    
    var path: String {
        switch self {
        case .auth(let router):
            return router.path
        case .post(let router):
            return router.path
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .auth(let router):
            return router.method
        case .post(let router):
            return router.method
        }
    }
    
    var header: [String: String] {
        switch self {
        case .auth(let router):
            return router.header
        case .post(let router):
            return router.header
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .auth(let router):
            return router.parameters
        case .post(let router):
            return router.parameters
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .auth(let router):
            return router.queryItems
        case .post(let router):
            return router.queryItems
        }
    }
    
    var body: Data? {
        switch self {
        case .auth(let router):
            return router.body
        case .post(let router):
            return router.body
        }
    }
    
    func asMultipartFormData() -> (MultipartFormData) -> Void {
        switch self {
        case .post(let router):
            return router.asMultipartFormData()
        default:
            return { _ in }
        }
    }
}
