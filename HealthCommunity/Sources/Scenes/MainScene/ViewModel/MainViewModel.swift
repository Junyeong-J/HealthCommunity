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
        let selectedSegment: ControlProperty<Int>
    }
    
    struct Output {
        let postButtonTapped: ControlEvent<Void>
        let selectedSegment: ControlProperty<Int>
        let items: Driver<[String]>
    }
    
    func transform(input: Input) -> Output {
        let segmentData: [Observable<[String]>] = [
                    Observable.just(["오운완 아이템 1", "오운완 아이템 2", "오운완 아이템 3"]),
                    Observable.just(["피드벡 아이템 1", "피드벡 아이템 2", "피드벡 아이템 3"]),
                    Observable.just(["소통 아이템 1", "소통 아이템 2", "소통 아이템 3"])
                ]
        
        let items = input.selectedSegment
                    .flatMapLatest { index in
                        segmentData[index]
                    }
                    .asDriver(onErrorJustReturn: [])
                
                return Output(
                    postButtonTapped: input.postButtonTap,
                    selectedSegment: input.selectedSegment,
                    items: items
                )
    }
}
