//
//  ProfileRouter.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/24/24.
//

import Foundation
import Alamofire

enum ProfileRouter: TargetType {
    
    case myProfile
    case updateProfile(nick: String, introduction: String, bench: String, squat: String, deadlift: String)
    
}

extension ProfileRouter {
    
    var baseURL: String {
        return APIURL.baseURL
    }
    
    var path: String {
        switch self {
        case .myProfile, .updateProfile:
            return APIURL.userProfileURL
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .myProfile:
            return .get
        case .updateProfile:
            return .put
        }
    }
    
    var header: [String: String] {
        switch self {
        case .myProfile:
            return [
                Header.sesacKey.rawValue: APIKey.key,
                Header.authorization.rawValue: UserDefaultsManager.shared.token
            ]
        case .updateProfile:
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
        switch self {
        case .myProfile, .updateProfile:
            return nil
        }
    }
    
    var body: Data? {
        switch self {
        case .myProfile:
            return nil
        case .updateProfile(let nick, let introduction, let bench, let squat, let deadlift):
            let params: [String: Any] = [
                Body.nick.rawValue: nick,
                Body.intro.rawValue: introduction,
                Body.measure.rawValue: "[\(bench), \(squat), \(deadlift)]"
            ]
            return try? JSONSerialization.data(withJSONObject: params, options: [])
        }
    }

}
