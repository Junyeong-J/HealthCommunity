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
    
}

extension PostRouter {
    
    var baseURL: String {
        return APIURL.baseURL
    }
    
    var path: String {
        switch self {
        case .imageUpload:
            return APIURL.imageUploadURL
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .imageUpload:
            return .post
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
        }
    }
    
    var parameters: Parameters? {
        return nil
    }
    
    var queryItems: [URLQueryItem]? {
        return nil
    }
    
    var body: Data? {
        switch self {
        case .imageUpload:
            return nil
        }
    }
    
    func asMultipartFormData() -> (MultipartFormData) -> Void {
            return { multipartFormData in
                switch self {
                case .imageUpload(let images):
                    for (index, image) in images.enumerated() {
                        if let imageData = image.pngData() {
                            multipartFormData.append(imageData, withName: "files", fileName: "image\(index + 1).png", mimeType: "image/png")
                        }
                    }
                }
            }
        }
}
