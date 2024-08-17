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
    let disposeBag = DisposeBag()
    
    struct Input {
        let passwordText: ControlProperty<String?>
    }
    
    struct Output {
        let isNumber: Observable<Bool>
        let isSpecialCharacter: Observable<Bool>
        let isLowercase: Observable<Bool>
        let isLengthValid: Observable<Bool>
        let isWhitespace: Observable<Bool>
    }
    
    func transform(input: Input) -> Output {
        let password = input.passwordText
            .orEmpty.asObservable()
        
        let isNumber = password.map { $0.rangeOfCharacter(from: .decimalDigits) != nil }
        let isSpecialCharacter = password.map { $0.rangeOfCharacter(from: .symbols) != nil || $0.rangeOfCharacter(from: .punctuationCharacters) != nil }
        let isLowercase = password.map { $0.rangeOfCharacter(from: .lowercaseLetters) != nil }
        let isLengthValid = password.map { $0.count >= 8 && $0.count <= 16 }
        let isWhitespace = password.map { $0.rangeOfCharacter(from: .whitespaces) == nil }
        
        return Output(isNumber: isNumber, isSpecialCharacter: isSpecialCharacter,
                      isLowercase: isLowercase, isLengthValid: isLengthValid,
                      isWhitespace: isWhitespace)
    }
}
