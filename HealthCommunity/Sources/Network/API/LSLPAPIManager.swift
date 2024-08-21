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
                            if let data = response.data, let result = response.response {
                                let errorMessage = self.parseErrorMessage(data: data, statusCode: result.statusCode, api: api)
                                observer(.success(.failure(.customError(statusCode: result.statusCode, message: errorMessage))))
                            } else {
                                observer(.success(.failure(.networkError(error))))
                            }
                        }
                    }
            } catch {
                observer(.success(.failure(.invalidRequest)))
            }
            return Disposables.create()
        }.debug("LSLP 통신")
    }
    
    func upload<T: Decodable>(api: LSLPRouter, model: T.Type) -> LSLPHandler<T> {
        return Single.create { observer -> Disposable in
            do {
                let request = try api.asURLRequest()
                AF.upload(multipartFormData: api.asMultipartFormData(), with: request)
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: model) { response in
                        switch response.result {
                        case .success(let value):
                            observer(.success(.success(value)))
                        case .failure(let error):
                            if let data = response.data, let result = response.response {
                                let errorMessage = self.parseErrorMessage(data: data, statusCode: result.statusCode, api: api)
                                observer(.success(.failure(.customError(statusCode: result.statusCode, message: errorMessage))))
                            } else {
                                observer(.success(.failure(.networkError(error))))
                            }
                        }
                    }
            } catch {
                observer(.success(.failure(.invalidRequest)))
            }
            return Disposables.create()
        }.debug("LSLP 통신")
    }
    
}

extension LSLPAPIManager {
    private func parseErrorMessage(data: Data, statusCode: Int, api: LSLPRouter) -> String {
        
        if let commonMessage = APIErrorMessages.commonMessages[statusCode] {
            return commonMessage
        }
        
        let apiMessages = APIErrorMessages.messages(for: api)
        if let apiMessage = apiMessages[statusCode] {
            return apiMessage
        }
        
        return "알 수 없는 오류가 발생했습니다."
    }
}
