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
        let registerButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let healthData: Driver<[HealthDataItem]>
        let itemSelected: Driver<IndexPath>
        let fetchButtonTapped: Driver<Void>
        let registerButtonTapped: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        
        let healthResult = input.registerButtonTapped
            .map { [weak self] in
                return self?.getHealthData() ?? ""
            }
            .asDriver(onErrorJustReturn: "")
        
        return Output(
            healthData: healthDataRelay.asDriver(),
            itemSelected: input.itemSelected.asDriver(),
            fetchButtonTapped: input.fetchButtonTapped.asDriver(),
            registerButtonTapped: healthResult
        )
    }
    
    func updateHealthData(type: HealthDataType, value: String) {
        var currentData = healthDataRelay.value
        if let index = currentData.firstIndex(where: { $0.type == type }) {
            currentData[index] = HealthDataItem(type: type, value: value)
            healthDataRelay.accept(currentData)
        }
    }
    
    private func getHealthData() -> String {
        let healthData = healthDataRelay.value
        
        var steps = "걸음"
        var distance = "거리"
        var calories = "칼로리"
        var standingHours = "서 있는 시간"
        
        for item in healthData {
            switch item.type {
            case .steps:
                steps = "\(item.value)"
            case .calories:
                calories = "\(item.value)"
            case .strengthTraining:
                distance = "\(item.value)"
            case .standingHours:
                standingHours = "\(item.value)"
            }
        }
        
        let output = "\(steps), \(distance), \(calories), \(standingHours)"
        return output
    }
}

