//
//  PasswordViewModel.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/17/24.
//

import Foundation
import RxSwift
import RxCocoa

final class PasswordViewModel: BaseViewModel {
    
    var email = BehaviorRelay<String>(value: "")
    let disposeBag = DisposeBag()
    
    struct Input {
        let passwordText: ControlProperty<String?>
        let password: Observable<String>
        let nextButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let isNumber: Observable<Bool>
        let isSpecialCharacter: Observable<Bool>
        let isLowercase: Observable<Bool>
        let isLengthValid: Observable<Bool>
        let isWhitespace: Observable<Bool>
        let nextButtonTapped: ControlEvent<Void>
        let password: Observable<String>
        let email: Observable<String>
        let isValidPassword: Observable<Bool>
    }
    
    func transform(input: Input) -> Output {
        let password = input.passwordText
            .orEmpty.asObservable()
        let email = email.asObservable()
        
        let isNumber = password.map { $0.rangeOfCharacter(from: .decimalDigits) != nil }
        let isSpecialCharacter = password.map { $0.rangeOfCharacter(from: .symbols) != nil || $0.rangeOfCharacter(from: .punctuationCharacters) != nil }
        let isLowercase = password.map { $0.rangeOfCharacter(from: .lowercaseLetters) != nil }
        let isLengthValid = password.map { $0.count >= 8 && $0.count <= 16 }
        let isWhitespace = password.map { $0.rangeOfCharacter(from: .whitespaces) == nil }
        
        let isValidPassword = Observable.combineLatest(isNumber, isSpecialCharacter, isLowercase, isLengthValid, isWhitespace)
            .map { $0 && $1 && $2 && $3 && $4 }
            .distinctUntilChanged()
            .share(replay: 1)
        
        return Output(
            isNumber: isNumber,
            isSpecialCharacter: isSpecialCharacter,
            isLowercase: isLowercase,
            isLengthValid: isLengthValid,
            isWhitespace: isWhitespace,
            nextButtonTapped: input.nextButtonTap,
            password: input.password,
            email: email,
            isValidPassword: isValidPassword
        )
    }
}

