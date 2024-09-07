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
    
    private let profileList = PublishSubject<[UserProfile]>()
    
    struct Input {
        let editProfileTap: ControlEvent<Void>
        let routineLikeTap: ControlEvent<Void>
        let logoutTap: ControlEvent<Void>
    }
    
    struct Output {
        let editProfileTapped: ControlEvent<Void>
        let routineLikeTapped: ControlEvent<Void>
        let myProfileList: Observable<[UserProfile]>
        let logoutTapped: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        
        fetchProfileData()
        
        return Output(editProfileTapped: input.editProfileTap,
                      routineLikeTapped: input.routineLikeTap,
                      myProfileList: profileList.asObservable(),
                      logoutTapped: input.logoutTap)
    }
    
    func fetchProfileData() {
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
                self.profileList.onNext(profiles)
            }, onFailure: { error in
                self.profileList.onNext([])
            })
            .disposed(by: disposeBag)
    }
}
