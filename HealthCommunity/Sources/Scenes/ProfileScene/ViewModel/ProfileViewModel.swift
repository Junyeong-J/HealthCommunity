//
//  ProfileViewModel.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/23/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ProfileViewModel: BaseViewModel {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        
    }
    
    struct Output {
        let menuItems: Driver<[String]>
    }
    
    func transform(input: Input) -> Output {
        let menuItems = Observable.just([
            "프로필 수정",
            "루틴 좋아요 목록",
            "목표 정하기",
            "탈퇴"
        ]).asDriver(onErrorJustReturn: [])
        
        return Output(menuItems: menuItems)
    }
    
}
