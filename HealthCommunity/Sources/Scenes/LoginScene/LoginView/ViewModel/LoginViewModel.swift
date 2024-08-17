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
    func transform(input: Input) -> Output {
        return Output()
    }
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let loginButtonTap: ControlEvent<Void>
        let email: Observable<String>
        let password: Observable<String>
    }
    
    struct Output {
//        let emailCheckResult: Observable<String>
    }
//    
//    func transform(input: Input) -> Output {
//        
//        let loginResult = input.loginButtonTap
//            .throttle(.seconds(1), scheduler: MainScheduler.instance)
//            .withLatestFrom(input.email, input.password)
//            .distinctUntilChanged()
//            .filter { !$0.isEmpty }
//            .flatMapLatest { email in
//                LSLPAPIManager.shared.request(api: ., model: EmailCheck.self)
//                    .map { result -> String in
//                        switch result {
//                        case .success(let response):
//                            return response.message
//                        case .failure(let error):
//                            return self.errorMessage(for: error)
//                        }
//                    }
//                    .catchAndReturn("알 수 없는 오류가 발생했습니다.")
//            }
//            .share(replay: 1)
//        
//        return Output(emailCheckResult: emailCheckResult)
//    }
//    
//    
//    private func errorMessage(for error: APIError) -> String {
//            switch error {
//            case .customError(let statusCode, let message):
//                switch statusCode {
//                case 400:
//                    return "이메일을 적어주세요."
//                case 409:
//                    return message
//                default:
//                    return "오류가 발생했습니다."
//                }
//            default:
//                return "네트워크 오류가 발생했습니다."
//            }
//        }
}
