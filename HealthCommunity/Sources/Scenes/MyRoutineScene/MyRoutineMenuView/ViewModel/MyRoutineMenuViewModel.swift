//
//  MyRoutineMenuViewModel.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/26/24.
//

import Foundation
import RxSwift
import RxCocoa

final class MyRoutineMenuViewModel: BaseViewModel {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let itemSelected: ControlEvent<IndexPath>
        let addButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let menuItems: Driver<[String]>
        let itemSelected: Driver<IndexPath>
        let addButtonTapped: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        let menuItems = Driver.just(["루틴 선택", "건강 데이터 작성 및 가져오기"])
        
        return Output(
            menuItems: menuItems,
            itemSelected: input.itemSelected.asDriver(),
            addButtonTapped: input.addButtonTapped.asDriver(onErrorJustReturn: ())
        )
    }
    
}
