//
//  NicknameViewModel.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/17/24.
//

import Foundation
import RxSwift
import RxCocoa

struct JoinResult {
    let success: Bool
    let message: String
}

final class NicknameViewModel: BaseViewModel {
    
    var email = BehaviorRelay<String>(value: "")
    var password = BehaviorRelay<String>(value: "")
    let disposeBag = DisposeBag()
    
    struct Input {
        let nicknameText: ControlProperty<String?>
        let joinCompleteTap: ControlEvent<Void>
    }
    
    struct Output {
        let isButtonEnabled: Driver<Bool>
        let joinResult: Observable<JoinResult>
    }
    
    func transform(input: Input) -> Output {
        let isButtonEnabled = input.nicknameText
            .orEmpty
            .map { nickname in
                let isLengthValid = nickname.count >= 2 && nickname.count <= 10
                let isWhitespace = nickname.rangeOfCharacter(from: .whitespaces) == nil
                return isLengthValid && isWhitespace
            }
            .asDriver(onErrorJustReturn: false)
        
        let joinResult = input.joinCompleteTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(Observable.combineLatest(email.asObservable(), password.asObservable(), input.nicknameText.orEmpty.asObservable()))
            .filter { !$0.0.isEmpty && !$0.1.isEmpty && !$0.2.isEmpty }
            .flatMapLatest { email, password, nick in
                LSLPAPIManager.shared.request(api: .auth(.SignUpAPI(email: email, password: password, nick: nick)),
                                              model: JoinResponse.self)
                .map { result -> JoinResult in
                    switch result {
                    case .success(_):
                        return JoinResult(success: true, message: MessageString.successSignUp.rawValue)
                    case .failure(let error):
                        return JoinResult(success: false, message: self.errorMessage(for: error))
                    }
                }
                .catchAndReturn(JoinResult(success: false, message: MessageString.failSignUp.rawValue))
            }
            .share(replay: 1)
        
        return Output(isButtonEnabled: isButtonEnabled, joinResult: joinResult)
    }
    
    
    private func errorMessage(for error: APIError) -> String {
        switch error {
        case .customError(let statusCode, _):
            switch statusCode {
            case 400:
                return "이메일을 적어주세요."
            case 409:
                return "이미 가입한 유저입니다"
            default:
                return "오류가 발생했습니다."
            }
        default:
            return "네트워크 오류가 발생했습니다."
        }
    }
    
}
