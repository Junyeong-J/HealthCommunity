//
//  LoginViewModel.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/17/24.
//

import Foundation
import RxSwift
import RxCocoa

final class LoginViewModel: BaseViewModel {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let loginButtonTap: ControlEvent<Void>
        let email: Observable<String>
        let password: Observable<String>
        let joinButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let joinButtonTapped: ControlEvent<Void>
        let loginResult: Observable<(String, Bool)>
    }
    
    func transform(input: Input) -> Output {
        
        let loginResult = input.loginButtonTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(Observable.combineLatest(input.email, input.password))
            .filter { !$0.0.isEmpty && !$0.1.isEmpty }
            .flatMapLatest { email, password in
                LSLPAPIManager.shared.request(api: .LoginAPI(email: email, password: password), model: LoginResponse.self)
                    .map { result -> (String, Bool) in
                        switch result {
                        case .success(let response):
                            UserDefaultsManager.shared.token = response.accessToken
                            UserDefaultsManager.shared.refreshToken = response.refreshToken
                            print(response)
                            return ("로그인 성공", true)
                        case .failure(let error):
                            let errorMessage: String
                            switch error {
                            case .customError(_, let message):
                                errorMessage = message
                            default:
                                errorMessage = "알 수 없는 오류가 발생했습니다."
                            }
                            return (errorMessage, false)
                        }
                    }
                    .catchAndReturn(("알 수 없는 오류가 발생했습니다.", false))
            }
            .share(replay: 1)
        
        return Output(joinButtonTapped: input.joinButtonTap, loginResult: loginResult)
    }
    
}
