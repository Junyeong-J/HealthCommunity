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
        let routineTypeSelection: Observable<RoutineType>
    }
    
    struct Output {
        let routineItems: Observable<[String]>
        let items: Observable<[RoutineRoutineItem]>
        let selectedRoutineType: Observable<RoutineType>
    }
    
    private let routineItemsSubject = BehaviorSubject<[RoutineRoutineItem]>(value: [])
    private let selectedRoutineType = BehaviorRelay<RoutineType>(value: .legs) // 초기값으로 하체
    
    func transform(input: Input) -> Output {
        
        let routineItems = Observable.just(RoutineType.allCases.map { $0.rawValue })
        
        let items = routineItemsSubject.asObservable()
        
        input.routineTypeSelection
            .bind(to: selectedRoutineType)
            .disposed(by: disposeBag)
        
        selectedRoutineType
            .subscribe(onNext: { [weak self] type in
                self?.handleRoutineTypeSelection(type: type)
            })
            .disposed(by: disposeBag)
        
        return Output(routineItems: routineItems, items: items, selectedRoutineType: selectedRoutineType.asObservable())
    }
    
    private func handleRoutineTypeSelection(type: RoutineType) {
        let routineItems: [RoutineRoutineItem]
        
        switch type {
        case .back:
            routineItems = RoutineData.backRoutines.map { RoutineRoutineItem(title: $0) }
        case .arms:
            routineItems = RoutineData.armsRoutines.map { RoutineRoutineItem(title: $0) }
        case .legs:
            routineItems = RoutineData.legsRoutines.map { RoutineRoutineItem(title: $0) }
        case .chest:
            routineItems = RoutineData.chestRoutines.map { RoutineRoutineItem(title: $0) }
        case .shoulders:
            routineItems = RoutineData.shouldersRoutines.map { RoutineRoutineItem(title: $0) }
        }
        
        routineItemsSubject.onNext(routineItems)
    }
}

