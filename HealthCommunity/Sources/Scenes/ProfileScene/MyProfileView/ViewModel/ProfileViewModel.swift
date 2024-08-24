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
    private let networkManager = LSLPAPIManager.shared
    
    struct Input {
        
    }
    
    struct Output {
        let menuItems: Driver<[String]>
        let myProfileList: Observable<[UserProfile]>
    }
    
    func transform(input: Input) -> Output {
        let profileList = PublishSubject<[UserProfile]>()
        let menuItems = Observable.just([
            "프로필 수정",
            "루틴 좋아요 목록",
            "목표 정하기",
            "탈퇴"
        ]).asDriver(onErrorJustReturn: [])
        
        networkManager.request(api: .profile(.myProfile), model: UserProfile.self)
            .flatMap { result -> Single<[UserProfile]> in
                switch result {
                case .success(let profile):
                    return Single.just([profile])
                case .failure(let error):
                    print("Error: \(error)")
                    return Single.just([])
                }
            }
            .subscribe(onSuccess: { profiles in
                profileList.onNext(profiles)
            }, onFailure: { error in
                profileList.onNext([])
            })
            .disposed(by: disposeBag)
        
        return Output(menuItems: menuItems, myProfileList: profileList)
    }
    
}
