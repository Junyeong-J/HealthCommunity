//
//  MyRoutineViewModel.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/26/24.
//

import Foundation
import RxSwift
import RxCocoa

final class MyRoutineViewModel: BaseViewModel {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let selectedSegmentIndex: ControlProperty<Int>
        let recordButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let selectedSegmentIndexTap: Driver<Int>
        let recordButtonTapped: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        let selectedSegmentIndexTap = input.selectedSegmentIndex.asDriver()
        
        return Output(selectedSegmentIndexTap: selectedSegmentIndexTap,
                      recordButtonTapped: input.recordButtonTap)
    }
    
}
