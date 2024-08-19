//
//  MainViewModel.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/19/24.
//

import Foundation
import RxSwift
import RxCocoa

final class MainViewModel: BaseViewModel {
    let disposeBag = DisposeBag()
    
    struct Input {
        let postButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let postButtonTapped: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        return Output(postButtonTapped: input.postButtonTap)
    }
}
