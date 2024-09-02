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
    private let maxRetryCount = 3
    let disposeBag = DisposeBag()
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
                                if result.statusCode == 419 {
                                    print("토큰갱신 api 시작")
                                    self.retryWithNewToken(api: api, model: model, retryCount: 0)
                                        .subscribe(observer)
                                        .disposed(by: self.disposeBag)
                                } else {
                                    let errorMessage = self.parseErrorMessage(data: data, statusCode: result.statusCode, api: api)
                                    observer(.success(.failure(.customError(statusCode: result.statusCode, message: errorMessage))))
                                }
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
    
    func uploadProfileRequest<T: Decodable>(nick: String, introduction: String, bench: String,
                                            squat: String, deadlift: String, model: T.Type, imageData: Data?) -> LSLPHandler<T> {
        return retryableUploadRequest(
            url: APIURL.baseURL + APIURL.userProfileURL,
            method: .put,
            parameters: [
                "nick": nick,
                "intro": introduction,
                "measure": "벤치: \(bench)kg 스쿼트: \(squat)kg 데드: \(deadlift)kg"
            ],
            imageData: imageData,
            model: model
        )
    }
    
    func uploadImagesRequest<T: Decodable>(model: T.Type, imageDatas: [Data]) -> LSLPHandler<T> {
        return retryableUploadRequest(
            url: APIURL.baseURL + APIURL.imageUploadURL,
            method: .post,
            parameters: nil,
            imageData: nil,
            model: model,
            imageDatas: imageDatas
        )
    }
    
    private func retryableUploadRequest<T: Decodable>(url: String, method: HTTPMethod, parameters: [String: String]?,
                                                      imageData: Data?, model: T.Type, retryCount: Int = 0,
                                                      imageDatas: [Data]? = nil) -> LSLPHandler<T> {
        guard retryCount < maxRetryCount else {
            return .just(.failure(.customError(statusCode: 419, message: "토큰 갱신에 실패하였습니다.")))
        }
        
        return Single.create { observer -> Disposable in
            let token = UserDefaultsManager.shared.token
            let headers: HTTPHeaders = [
                Header.sesacKey.rawValue: APIKey.key,
                Header.contentType.rawValue: Header.multipart.rawValue,
                Header.authorization.rawValue: token
            ]
            
            AF.upload(multipartFormData: { multipartFormData in
                if let image = imageData {
                    multipartFormData.append(image, withName: "profile", fileName: "profile.png", mimeType: "image/png")
                }
                
                if let params = parameters {
                    for (key, value) in params {
                        multipartFormData.append(Data(value.utf8), withName: key)
                    }
                }
                
                if let images = imageDatas {
                    for (index, image) in images.enumerated() {
                        let fileName = "Imagefile\(index + 1).jpg"
                        multipartFormData.append(image, withName: "files", fileName: fileName, mimeType: "image/jpeg")
                    }
                }
            }, to: url, usingThreshold: UInt64.init(), method: method, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: model) { response in
                switch response.result {
                case .success(let value):
                    observer(.success(.success(value)))
                case .failure(let error):
                    if let data = response.data, let result = response.response, result.statusCode == 419 {
                        print("토큰 갱신 시도")
                        self.retryWithNewToken(api: nil, model: model, retryCount: retryCount)
                            .subscribe(observer)
                            .disposed(by: self.disposeBag)
                    } else {
                        if let responseData = response.data {
                            let errorMessage = self.parseErrorMessage(data: responseData, statusCode: response.response?.statusCode ?? 0)
                            
                            observer(.success(.failure(.customError(statusCode: response.response?.statusCode ?? 0, message: errorMessage))))
                        }
                    }
                }
            }
            
            return Disposables.create()
        }
    }
    
    private func parseErrorMessage(data: Data, statusCode: Int) -> String {
        return "오류 메시지"
    }
    
}

extension LSLPAPIManager {
    
    private func retryWithNewToken<T: Decodable>(api: LSLPRouter?, model: T.Type, retryCount: Int) -> LSLPHandler<T> {
        guard retryCount < maxRetryCount else {
            return .just(.failure(.customError(statusCode: 419, message: "토큰 갱신에 실패하였습니다.")))
        }
        
        return refreshToken()
            .flatMap { success -> LSLPHandler<T> in
                if success {
                    if let api = api {
                        return self.request(api: api, model: model)
                    } else {
                        return self.retryableUploadRequest(url: "", method: .post, parameters: nil, imageData: nil, model: model, retryCount: retryCount + 1)
                    }
                } else {
                    return .just(.failure(.customError(statusCode: 419, message: "토큰 갱신에 실패하였습니다.")))
                }
            }
            .catch { _ in
                return .just(.failure(.customError(statusCode: 419, message: "토큰 갱신에 실패하였습니다.")))
            }
    }
    
    private func refreshToken() -> Single<Bool> {
        return Single.create { observer in
            let request = try? AuthRouter.TokenAPI.asURLRequest()
            AF.request(request!)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: TokenResponse.self) { response in
                    switch response.result {
                    case .success(let tokenResponse):
                        print("성공: \(tokenResponse)")
                        UserDefaultsManager.shared.token = tokenResponse.accessToken
                        observer(.success(true))
                    case .failure(let error):
                        print("실패: \(error)")
                        observer(.success(false))
                    }
                }
            return Disposables.create()
        }
    }
    
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
