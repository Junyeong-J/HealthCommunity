//
//  OnBoardingViewModel.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/15/24.
//

import Foundation
import RxSwift
import RxCocoa

final class OnBoardingViewModel: BaseViewModel {
    let disposeBag = DisposeBag()
    
    struct Input {
        let startButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let startButtonTapped: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        return Output(startButtonTapped: input.startButtonTap)
    }
}
