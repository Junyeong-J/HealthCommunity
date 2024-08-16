//
//  LSLPAPIManager.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/15/24.
//

import Foundation
import Alamofire
import RxSwift

final class LSLPAPIManager {
    
    static let shared = LSLPAPIManager()
    
    private init() { }
    
    typealias LSLPHandler<T: Decodable> = Single<Result<T, APIError>>
    
    func request<T: Decodable>(api: LSLPRouter, model: T.Type) ->  LSLPHandler<T> {
        return Single.create { observer -> Disposable in
            do {
                let request = try api.asURLRequest()
                AF.request(request)
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: model) { response in
                        switch response.result {
                        case .success(let value):
                            observer(.success(.success(value)))
                        case .failure(let error):
                            observer(.success(.failure(.networkError(error))))
                        }
                    }
            } catch {
                observer(.success(.failure(.invalidRequest)))
            }
            return Disposables.create()
        }.debug("LSLP 통신")
    }
}
