//
//  CommentRouter.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/25/24.
//

import Foundation
import Alamofire

enum CommentRouter: TargetType {
    
    case commentPost(id: String, content: String)
    
}

extension CommentRouter {
    
    var baseURL: String {
        return APIURL.baseURL
    }
    
    var path: String {
        switch self {
        case .commentPost(let id, _):
            return APIURL.commentPostURL + id + APIURL.commentSecondPostURL
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .commentPost:
            return .post
        }
    }
    
    var header: [String: String] {
        switch self {
        case .commentPost:
            return [
                Header.contentType.rawValue: Header.json.rawValue,
                Header.sesacKey.rawValue: APIKey.key,
                Header.authorization.rawValue: UserDefaultsManager.shared.token
            ]
        }
    }
    
    var parameters: Parameters? {
        return nil
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .commentPost:
            return nil
        }
    }
    
    var body: Data? {
        switch self {
        case .commentPost(_, let content):
            let params: [String: Any] = [
                Body.content.rawValue: content
            ]
            return try? JSONSerialization.data(withJSONObject: params, options: [])
        }
    }

}
