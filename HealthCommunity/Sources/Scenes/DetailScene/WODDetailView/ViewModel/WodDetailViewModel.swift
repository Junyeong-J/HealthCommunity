//
//  WodDetailViewModel.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/25/24.
//

import Foundation
import RxSwift
import RxCocoa

final class WodDetailViewModel: BaseViewModel {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let commentTap: ControlEvent<Void>
    }
    
    struct Output {
        let commentTapped: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        
        return Output(commentTapped: input.commentTap)
    }
}
