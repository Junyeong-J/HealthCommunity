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
    
    private let networkManager = LSLPAPIManager.shared
    
    struct Input {
        let itemSelected: ControlEvent<IndexPath>
        let routineData: Observable<[String: [String]]>
        let healthData: Observable<String>
        let addButtonTapped: ControlEvent<Void>
        let contentData: Observable<String>
    }
    
    struct Output {
        let menuItems: Driver<[String]>
        let itemSelected: Driver<IndexPath>
        let addButtonTapped: Observable<Bool>
        let routineList: Observable<[String: [String]]>
        let healthData: Observable<String>
    }
    
    func transform(input: Input) -> Output {
        let menuItems = Driver.just(["루틴 선택", "건강 데이터 작성 및 가져오기"])
        
        let formattedHealthData = input.healthData
            .map { healthData -> String in
                let numbers = healthData
                    .components(separatedBy: CharacterSet(charactersIn: " ,걸음km칼로리분서있기"))
                    .filter { !$0.isEmpty }
                return numbers.joined(separator: ", ")
            }
        
        input.contentData
            .subscribe(with: self) { owner, data in
                print(data)
            }
            .disposed(by: disposeBag)
        
        let postResult = input.addButtonTapped
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(Observable.combineLatest(input.contentData, formattedHealthData))
            .flatMapLatest { [weak self] routineData, healthData -> Observable<Bool> in
                guard let self = self else { return Observable.just(false) }
                
                return self.networkManager.request(
                    api: .post(.posts(
                        title: "",
                        content: routineData,
                        content1: healthData,
                        productId: "내운동기록"
                    )),
                    model: PostModelResponse.self
                )
                .map { result -> Bool in
                    switch result {
                    case .success(let value):
                        print(value)
                        return true
                    case .failure(let error):
                        print("Error: \(error)")
                        return false
                    }
                }
                .asObservable()
            }
            .share(replay: 1)
        
        return Output(
            menuItems: menuItems,
            itemSelected: input.itemSelected.asDriver(),
            addButtonTapped: postResult,
            routineList: input.routineData,
            healthData: input.healthData
        )
    }
    
}
