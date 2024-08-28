//
//  MyRoutineViewModel.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/26/24.
//

import Foundation
import RxSwift
import RxCocoa

final class MyRoutineViewModel: BaseViewModel {
    
    let disposeBag = DisposeBag()
    private let networkManager = LSLPAPIManager.shared
    
    struct Input {
        let selectedSegmentIndex: ControlProperty<Int>
        let recordButtonTap: ControlEvent<Void>
        let selectedDate: Observable<String>
    }
    
    struct Output {
        let selectedSegmentIndexTap: Driver<Int>
        let recordButtonTapped: Observable<String>
        let myList: Observable<[Post]>
    }
    
    func transform(input: Input) -> Output {
        let selectedSegmentIndexTap = input.selectedSegmentIndex.asDriver()
        let profileList = PublishSubject<[UserProfile]>()
        let myList = PublishSubject<[Post]>()
        
        let recordButtonTapped = input.recordButtonTap
            .withLatestFrom(input.selectedDate)
        
        networkManager.request(api: .profile(.myProfile), model: UserProfile.self)
            .flatMap { result in
                switch result {
                case .success(let profile):
                    return self.networkManager.request(api: .post(.userByPostAPI(id: profile.userId, productId: "내운동기록")), model: PostViewResponse.self)
                        .flatMap { postResult -> Single<[UserProfile]> in
                            switch postResult {
                            case .success(let postResponse):
                                print("성공:", postResponse)
                                myList.onNext(postResponse.data)
                                return Single.just([profile])
                            case .failure(let error):
                                print("실패:", error)
                                return Single.just([profile])
                            }
                        }
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
        
        
        return Output(selectedSegmentIndexTap: selectedSegmentIndexTap,
                      recordButtonTapped: recordButtonTapped,
                      myList: myList)
    }
    
}
