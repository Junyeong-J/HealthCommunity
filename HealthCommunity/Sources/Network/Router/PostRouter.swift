//
//  PostRouter.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/22/24.
//

import Foundation
import Alamofire
import UIKit

enum PostRouter: TargetType {
    
    case imageUpload(images: [UIImage])
    case posts(content: String, content1: String, content2: String, content3: String, content4: String, productId: String, files: [String]?)
    case myRoutinePosts(title: String, content: String, content1: String, productId: String)
    case postView(next: String, limit: String, productId: String)
    case specificPost(id: String)
    case userByPostAPI(id: String, productId: String)
    case likeAPI(id: String, likeState: Bool)
    case likeMeAPI(next: String, limit: String)
    case deletePost(id: String)
    
}

extension PostRouter {
    
    var baseURL: String {
        return APIURL.baseURL
    }
    
    var path: String {
        switch self {
        case .imageUpload:
            return APIURL.imageUploadURL
        case .postView:
            return APIURL.postViewURL
        case .specificPost(let id):
            return APIURL.specificPostViewURL + id
        case .myRoutinePosts, .posts:
            return APIURL.postURL
        case .userByPostAPI(let id, _):
            return APIURL.userByPostURL + id
        case .likeAPI(let id, _):
            return APIURL.likeURL + id + APIURL.likeSecondURL
        case .likeMeAPI:
            return APIURL.likesMeURL
        case .deletePost(let id):
            return APIURL.deletePostURL + id
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .imageUpload, .myRoutinePosts, .posts, .likeAPI:
            return .post
        case .postView, .specificPost, .userByPostAPI, .likeMeAPI:
            return .get
        case .deletePost:
            return .delete
        }
    }
    
    var header: [String: String] {
        switch self {
        case .imageUpload:
            return [
                Header.contentType.rawValue: Header.multipart.rawValue,
                Header.sesacKey.rawValue: APIKey.key,
                Header.authorization.rawValue: UserDefaultsManager.shared.token
            ]
        case .postView, .specificPost, .userByPostAPI, .likeMeAPI, .deletePost:
            return [
                Header.sesacKey.rawValue: APIKey.key,
                Header.authorization.rawValue: UserDefaultsManager.shared.token
            ]
        case .myRoutinePosts, .posts, .likeAPI:
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
        case .imageUpload, .specificPost, .myRoutinePosts, .posts, .likeAPI, .deletePost:
            return nil
        case .postView(let next, let limit, let productId):
            return [
                URLQueryItem(name: QueryItems.next.rawValue, value: next),
                URLQueryItem(name: QueryItems.limit.rawValue, value: limit),
                URLQueryItem(name: QueryItems.productId.rawValue, value: productId)
            ]
        case .userByPostAPI(_, let productId):
            return [
                URLQueryItem(name: QueryItems.limit.rawValue, value: "365"),
                URLQueryItem(name: QueryItems.productId.rawValue, value: productId)
            ]
        case .likeMeAPI(let next, let limit):
            return [
                URLQueryItem(name: QueryItems.limit.rawValue, value: "365"),
//                URLQueryItem(name: QueryItems.next.rawValue, value: next)
            ]
        }
    }
    
    var body: Data? {
        switch self {
        case .imageUpload, .postView, .specificPost, .userByPostAPI, .likeMeAPI, .deletePost:
            return nil
        case .myRoutinePosts(let title, let content, let content1, let productId):
            let params: [String: Any] = [
                Body.productID.rawValue: productId,
                Body.content.rawValue: content,
                Body.content1.rawValue: content1,
                Body.title.rawValue: title
            ]
            return try? JSONSerialization.data(withJSONObject: params, options: [])
        case .posts(let content, let content1, let content2, let content3, let content4, let productId, let files):
            var params: [String: Any] = [
                Body.productID.rawValue: productId,
                Body.content.rawValue: content,
                Body.content1.rawValue: content1,
                Body.content2.rawValue: content2,
                Body.content3.rawValue: content3,
                Body.content4.rawValue: content4
            ]
            if let files = files {
                params[Body.files.rawValue] = files
            }
            return try? JSONSerialization.data(withJSONObject: params, options: [])
        case .likeAPI(_, let likeState):
            let likeStatus: Bool = likeState
            let params: [String: Any] = [
                Body.like.rawValue: likeStatus
            ]
            return try? JSONSerialization.data(withJSONObject: params, options: [])
        }
    }
    
}
