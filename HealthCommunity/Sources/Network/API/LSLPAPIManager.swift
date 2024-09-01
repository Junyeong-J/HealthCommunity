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
                
                if let url = request.url {
                                print("Request URL: \(url)")
                            }
                            if let body = request.httpBody {
                                if let json = try? JSONSerialization.jsonObject(with: body, options: []) {
                                    print("Request Body: \(json)")
                                } else if let bodyString = String(data: body, encoding: .utf8) {
                                    print("Request Body: \(bodyString)")
                                }
                            }
                            print("Request Headers: \(request.allHTTPHeaderFields ?? [:])")
                
                AF.request(request)
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: model) { response in
                        switch response.result {
                        case .success(let value):
                            print("123123")
                            observer(.success(.success(value)))
                        case .failure(let error):
                            if let data = response.data, let result = response.response {
                                if result.statusCode == 419 {
                                    print("토큰갱신 api 시작")
                                    self.retryWithNewToken(api: api, model: model, retryCount: 0)
                                        .subscribe(observer)
                                        .disposed(by: self.disposeBag)
                                } else {
                                    print("1avasvasdv")
                                    let errorMessage = self.parseErrorMessage(data: data, statusCode: result.statusCode, api: api)
                                    observer(.success(.failure(.customError(statusCode: result.statusCode, message: errorMessage))))
                                }
                            } else {
                                print("12321dcasvsa")
                                observer(.success(.failure(.networkError(error))))
                            }
                        }
                    }
            } catch {
                print("12312adasd3")
                observer(.success(.failure(.invalidRequest)))
            }
            return Disposables.create()
        }.debug("LSLP 통신")
    }
    
    func uploadProfileRequest<T: Decodable>(nick: String, introduction: String, bench:String,
                                     squat: String, deadlift: String, model: T.Type, imageData: Data?) -> LSLPHandler<T> {
        return Single.create { observer -> Disposable in
            let url = APIURL.baseURL + APIURL.userProfileURL
            
            let token = UserDefaultsManager.shared.token
            
            let header: HTTPHeaders = [
                Header.sesacKey.rawValue: APIKey.key,
                Header.contentType.rawValue: Header.multipart.rawValue,
                Header.authorization.rawValue: token
            ]
            
            AF.upload(multipartFormData: { multipartFormData in
                if let image = imageData {
                    multipartFormData.append(image, withName: "profile", fileName: "profile.png", mimeType: "image/png")
                }
                multipartFormData.append(Data(nick.utf8), withName: Body.nick.rawValue)
                multipartFormData.append(Data(introduction.utf8), withName: Body.intro.rawValue)
                multipartFormData.append(Data("벤치: \(bench)kg 스쿼트: \(squat)kg 데드: \(deadlift)kg".utf8), withName: Body.measure.rawValue)
            }, to: url, usingThreshold: UInt64.init(), method: .put, headers: header)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: model) { response in
                switch response.result {
                case .success(let value):
                    observer(.success(.success(value)))
                case .failure(let error):
                    if let data = response.data, let result = response.response {
                        let errorMessage = self.parseErrorMessage(data: data, statusCode: result.statusCode)
                        observer(.success(.failure(.customError(statusCode: result.statusCode, message: errorMessage))))
                    } else {
                        observer(.success(.failure(.networkError(error))))
                    }
                }
            }
            
            return Disposables.create()
        }
    }
    
    func uploadImagesRequest<T: Decodable>(model: T.Type, imageDatas: [Data]) -> LSLPHandler<T> {
        return Single.create { observer -> Disposable in
            let url = APIURL.baseURL + APIURL.imageUploadURL
            
            let token = UserDefaultsManager.shared.token
            
            let header: HTTPHeaders = [
                Header.sesacKey.rawValue: APIKey.key,
                Header.contentType.rawValue: Header.multipart.rawValue,
                Header.authorization.rawValue: token
            ]
            
            AF.upload(multipartFormData: { multipartFormData in
                for (index, image) in imageDatas.enumerated() {
                    let fileName = "Imagefile\(index + 1).jpg"
                    multipartFormData.append(image, withName: "files", fileName: fileName, mimeType: "image/jpeg")
                }
            }, to: url, usingThreshold: UInt64.init(), method: .post, headers: header)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: model) { response in
                switch response.result {
                case .success(let value):
                    observer(.success(.success(value)))
                case .failure(let error):
                    if let data = response.data, let result = response.response {
                        let errorMessage = self.parseErrorMessage(data: data, statusCode: result.statusCode)
                        observer(.success(.failure(.customError(statusCode: result.statusCode, message: errorMessage))))
                    } else {
                        observer(.success(.failure(.networkError(error))))
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
    
    private func retryWithNewToken<T: Decodable>(api: LSLPRouter, model: T.Type, retryCount: Int) -> LSLPHandler<T> {
        guard retryCount < maxRetryCount else {
            return .just(.failure(.customError(statusCode: 419, message: "토큰 갱신에 실패하였습니다.")))
        }
        
        return refreshToken()
            .flatMap { success -> LSLPHandler<T> in
                if success {
                    return self.request(api: api, model: model)
                } else {
                    return .just(.failure(.customError(statusCode: 419, message: "토큰 갱신에 실패하였습니다.")))
                }
            }
            .catch { error in
                return .just(.failure(.customError(statusCode: 419, message: "토큰 갱신에 실패하였습니다.")))
            }
            .flatMap { result -> LSLPHandler<T> in
                switch result {
                case .success:
                    return .just(result)
                case .failure:
                    return self.retryWithNewToken(api: api, model: model, retryCount: retryCount + 1)
                }
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
