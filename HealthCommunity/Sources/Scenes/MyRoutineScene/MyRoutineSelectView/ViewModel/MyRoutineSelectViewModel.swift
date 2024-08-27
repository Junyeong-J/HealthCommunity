//
//  MyRoutineSelectViewModel.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/27/24.
//

import Foundation
import RxSwift
import RxCocoa

final class MyRoutineSelectViewModel: BaseViewModel {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let itemSelected: ControlEvent<IndexPath>
    }
    
    struct Output {
        let fitnessAreas: Driver<[String]>
        let itemSelected: Driver<IndexPath>
        let routines: Driver<[String]>
    }
    
    func transform(input: Input) -> Output {
        let fitnessAreas = Observable.just([
            "하체", "가슴", "등", "어깨", "팔", "역도", "복근", "기타", "유산소"
        ]).asDriver(onErrorJustReturn: [])
        
        let itemSelected = input.itemSelected.asDriver()
        
        let routines = input.itemSelected
            .map { indexPath -> [String] in
                switch indexPath.row {
                case 0: return RoutineData.legsRoutines
                case 1: return RoutineData.chestRoutines
                case 2: return RoutineData.backRoutines
                case 3: return RoutineData.shouldersRoutines
                case 4: return RoutineData.armsRoutines
                case 5: return RoutineData.weightliftingRoutines
                case 6: return RoutineData.absRoutines
                case 7: return RoutineData.othersRoutines
                case 8: return RoutineData.cardioRoutines
                default: return []
                }
            }
            .asDriver(onErrorJustReturn: [])
        
        return Output(
            fitnessAreas: fitnessAreas,
            itemSelected: itemSelected,
            routines: routines
        )
    }
    
    func iconName(for index: Int) -> String {
        switch index {
        case 0: return "figure.strengthtraining.functional"
        case 1: return "figure.mixed.cardio"
        case 2: return "figure.rower"
        case 3: return "figure.play"
        case 4: return "dumbbell"
        case 5: return "figure.strengthtraining.traditional"
        case 6: return "figure.core.training"
        case 7: return "figure.cooldown"
        case 8: return "figure.highintensity.intervaltraining"
        default: return "figure.strengthtraining.functional"
        }
    }
}

