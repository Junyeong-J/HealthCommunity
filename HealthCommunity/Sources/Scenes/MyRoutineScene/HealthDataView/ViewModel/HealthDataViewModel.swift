//
//  HealthDataViewModel.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/26/24.
//

import Foundation
import RxSwift
import RxCocoa
import HealthKit


enum HealthDataType {
    case steps
    case calories
    case strengthTraining
    case standingHours
}

struct HealthDataItem {
    let type: HealthDataType
    let value: String
}

final class HealthDataViewModel: BaseViewModel {
    
    let disposeBag = DisposeBag()
    
    private let healthDataRelay = BehaviorRelay<[HealthDataItem]>(value: [
        HealthDataItem(type: .steps, value: "0 걸음"),
        HealthDataItem(type: .calories, value: "0 칼로리"),
        HealthDataItem(type: .strengthTraining, value: "0분"),
        HealthDataItem(type: .standingHours, value: "0.0시간")
    ])
    
    struct Input {
        let fetchButtonTapped: ControlEvent<Void>
        let itemSelected: ControlEvent<IndexPath>
    }
    
    struct Output {
        let healthData: Driver<[HealthDataItem]>
        let itemSelected: Driver<IndexPath>
        let fetchButtonTapped: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        let fetchButtonTapped = input.fetchButtonTapped.asDriver()
        
        return Output(
            healthData: healthDataRelay.asDriver(),
            itemSelected: input.itemSelected.asDriver(),
            fetchButtonTapped: fetchButtonTapped
        )
    }
    
    func updateHealthData(type: HealthDataType, value: String) {
        var currentData = healthDataRelay.value
        if let index = currentData.firstIndex(where: { $0.type == type }) {
            currentData[index] = HealthDataItem(type: type, value: value)
            healthDataRelay.accept(currentData)
        }
    }
}

