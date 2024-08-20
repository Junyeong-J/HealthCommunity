//
//  WODViewModel.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/19/24.
//

import Foundation
import RxSwift
import RxCocoa

final class WODViewModel: BaseViewModel {
    let disposeBag = DisposeBag()
    
    struct Input {
        let albumButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let albumButtonTapped: ControlEvent<Void>
        let tableList: Observable<[String]>
    }
    
    func transform(input: Input) -> Output {
        
        let tableList = Observable.just(WODTableTitles.allTitles)
        
        return Output(albumButtonTapped: input.albumButtonTap, tableList: tableList)
    }
}
