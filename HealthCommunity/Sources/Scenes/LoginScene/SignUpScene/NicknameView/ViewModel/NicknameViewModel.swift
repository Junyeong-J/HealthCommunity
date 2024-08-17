//
//  NicknameViewModel.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/17/24.
//

import Foundation
import RxSwift
import RxCocoa

final class NicknameViewModel: BaseViewModel {
    let disposeBag = DisposeBag()
    
    struct Input {
        let nicknameText: ControlProperty<String?>
    }
    
    struct Output {
        let isButtonEnabled: Driver<Bool>
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
        
        return Output(isButtonEnabled: isButtonEnabled)
    }
}
