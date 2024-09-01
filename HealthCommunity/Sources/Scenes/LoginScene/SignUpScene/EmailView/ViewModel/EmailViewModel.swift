//
//  EmailViewModel.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/16/24.
//

import Foundation
import RxSwift
import RxCocoa

final class EmailViewModel: BaseViewModel {
    
    let disposeBag = DisposeBag()
    private let isEmail = BehaviorRelay<Bool>(value: false)
    
    struct Input {
        let emailCheckButtonTap: ControlEvent<Void>
        let email: Observable<String>
        let nextButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let emailCheckResult: Observable<String>
        let isEmail: Observable<Bool>
        let nextButtonTapped: ControlEvent<Void>
        let email: Observable<String>
    }
    
    func transform(input: Input) -> Output {
        
        let emailCheckResult = input.emailCheckButtonTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.email)
            .distinctUntilChanged()
            .filter { !$0.isEmpty }
            .flatMapLatest { email in
                LSLPAPIManager.shared.request(api: .auth(.EmailCheck(email: email)), model: EmailCheck.self)
                    .flatMap { [weak self] result -> Single<(String, Bool)> in
                        switch result {
                        case .success(let response):
                            self?.isEmail.accept(true)
                            return Single.just((response.message, true))
                        case .failure(let error):
                            let errorMessage = self?.errorMessage(error: error) ?? "오류가 발생했습니다."
                            self?.isEmail.accept(false)
                            return Single.just((errorMessage, false))
                        }
                    }
            }
            .share(replay: 1)
        
        let emailCheckResultText = emailCheckResult.map { $0.0 }
        let isEmail = isEmail.asObservable()
        
        return Output(emailCheckResult: emailCheckResultText, isEmail: isEmail, nextButtonTapped: input.nextButtonTap, email: input.email)
    }
}

extension EmailViewModel {
    
    private func errorMessage(error: APIError) -> String {
        switch error {
        case .customError(_, let message):
            return message
        default:
            return "네트워크 오류가 발생했습니다."
        }
    }
    
}
