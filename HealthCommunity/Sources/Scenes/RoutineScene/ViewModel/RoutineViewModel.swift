//
//  RoutineViewModel.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/21/24.
//

import Foundation
import RxSwift
import RxCocoa


final class RoutineViewModel: BaseViewModel {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        
    }
    
    struct Output {
        let routineItems: Observable<[String]>
        let tableItems: Observable<[String]>
    }
    
    func transform(input: Input) -> Output {
        let routineItems = Observable.just(["하체", "가슴", "등", "어깨", "팔"])
        let tableItems = Observable.just(Array(repeating: "운동 루틴", count: 30))
        
        return Output(routineItems: routineItems, tableItems: tableItems)
    }
}
