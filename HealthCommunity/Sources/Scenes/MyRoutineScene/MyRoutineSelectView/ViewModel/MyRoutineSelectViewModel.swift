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
    
    private var routinesDict: [Int: [Routine]] = [
        0: RoutineData.legsRoutines,
        1: RoutineData.chestRoutines,
        2: RoutineData.backRoutines,
        3: RoutineData.shouldersRoutines,
        4: RoutineData.armsRoutines,
        5: RoutineData.weightliftingRoutines,
        6: RoutineData.absRoutines,
        7: RoutineData.othersRoutines,
        8: RoutineData.cardioRoutines
    ]
    
    private var selectedRoutines = BehaviorSubject<[Routine]>(value: [])
    private var currentCategoryIndex: Int = 0
    private let routine = BehaviorSubject<[Routine]>(value: [])
    
    struct Input {
        let itemSelected: ControlEvent<IndexPath>
        let checkBoxToggled: Observable<Int>
        let deleteRoutine: Observable<Int>
        let selectedButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let fitnessAreas: Driver<[String]>
        let itemSelected: Driver<IndexPath>
        let routines: Observable<[Routine]>
        let selectedRoutines: Observable<[Routine]>
        let buttonTitle: Observable<String>
        let selectedButtonTapped: Observable<[String: [String]]>
    }
    
    func transform(input: Input) -> Output {
        let fitnessAreas = Observable.just(
            RoutineData.categories
        ).asDriver(onErrorJustReturn: [])
        
        let itemSelected = input.itemSelected.asDriver()
        
        itemSelected
            .drive(with: self, onNext: { owner, indexPath in
                owner.currentCategoryIndex = indexPath.row
                
                if let routines = owner.routinesDict[indexPath.row] {
                    owner.routine.onNext(routines)
                }
            })
            .disposed(by: disposeBag)
        
        input.checkBoxToggled
            .bind(with: self, onNext: { owner, index in
                owner.toggleCheckBox(index: index)
            })
            .disposed(by: disposeBag)
        
        input.deleteRoutine
            .bind(with: self, onNext: { owner, index in
                owner.removeSelectedRoutine(index: index)
            })
            .disposed(by: disposeBag)
        
        let buttonTitle = selectedRoutines
            .map { selectedRoutine in
                return "\(selectedRoutine.count)개 운동 선택"
            }
            .asObservable()
        
        let selectedButtonTapped = input.selectedButtonTap
            .map { [weak self] in
                self?.getSelectedRoutines() ?? [:]
            }
            .asObservable()
        
        return Output(
            fitnessAreas: fitnessAreas,
            itemSelected: itemSelected,
            routines: routine.asObservable(),
            selectedRoutines: selectedRoutines.asObservable(),
            buttonTitle: buttonTitle,
            selectedButtonTapped: selectedButtonTapped
        )
    }
    
    func initSelectedRoutines(_ routines: [String: [String]]) {
        var selectedRoutines = [Routine]()
        
        for (category, routineNames) in routines {
            if let categoryIndex = RoutineData.categories.firstIndex(of: category) {
                var routinesInCategory = routinesDict[categoryIndex] ?? []
                for (index, routine) in routinesInCategory.enumerated() {
                    if routineNames.contains(routine.name) {
                        routinesInCategory[index].isSelected = true
                        selectedRoutines.append(routinesInCategory[index])
                    } else {
                        routinesInCategory[index].isSelected = false
                    }
                }
                routinesDict[categoryIndex] = routinesInCategory
            }
        }
        
        self.selectedRoutines.onNext(selectedRoutines)
        
        if let currentRoutines = routinesDict[currentCategoryIndex] {
            routine.onNext(currentRoutines)
        }
    }

    
    
    private func toggleCheckBox(index: Int) {
        guard var currentRoutines = try? routine.value() else {
            return
        }
        currentRoutines[index].isSelected.toggle()
        
        var selected = (try? selectedRoutines.value()) ?? []
        
        if currentRoutines[index].isSelected {
            selected.append(currentRoutines[index])
        } else {
            if let selectedIndex = selected.firstIndex(where: { $0.name == currentRoutines[index].name }) {
                selected.remove(at: selectedIndex)
            }
        }
        
        selectedRoutines.onNext(selected)
        
        routinesDict[currentCategoryIndex] = currentRoutines
        routine.onNext(currentRoutines)
    }
    
    func loadData() {
        if let initialRoutines = routinesDict[0] {
            routine.onNext(initialRoutines)
        }
    }
    
    private func removeSelectedRoutine(index: Int) {
        var selected = (try? selectedRoutines.value()) ?? []
        let routineToRemove = selected.remove(at: index)
        
        for (categoryIndex, routines) in routinesDict {
            if let routineIndex = routines.firstIndex(where: { $0.name == routineToRemove.name }) {
                routinesDict[categoryIndex]?[routineIndex].isSelected = false
                if categoryIndex == currentCategoryIndex {
                    routine.onNext(routinesDict[categoryIndex]!)
                }
                break
            }
        }
        
        selectedRoutines.onNext(selected)
    }
    
    private func getSelectedRoutines() -> [String: [String]] {
        var myRoutines: [String: [String]] = [:]
        
        guard let select = try? selectedRoutines.value() else { return myRoutines }
        
        routinesDict.forEach { index, routines in
            let category = RoutineData.categories[index]
            let selectedCategory = routines.filter { routine in
                select.contains(where: { $0.name == routine.name })
            }
            if !selectedCategory.isEmpty {
                myRoutines[category] = selectedCategory.map { $0.name }
            }
        }
        
        return myRoutines
    }
    
}

