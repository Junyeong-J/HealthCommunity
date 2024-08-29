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
    
    private let profileList = PublishSubject<[UserProfile]>()
    private let myList = PublishSubject<[Post]>()
    
    struct Input {
        let selectedSegmentIndex: ControlProperty<Int>
        let recordButtonTap: ControlEvent<Void>
        let selectedDate: Observable<String>
    }
    
    struct Output {
        let selectedSegmentIndexTap: Driver<Int>
        let recordButtonTapped: Observable<String>
        let myList: Observable<[Post]>
        let setDateList: Observable<[Routines]>
        let content1List: Observable<[String]>
    }
    
    func transform(input: Input) -> Output {
        let selectedSegmentIndexTap = input.selectedSegmentIndex.asDriver()
        
        let recordButtonTapped = input.recordButtonTap
            .withLatestFrom(input.selectedDate)
        
        let resultList = input.selectedDate
            .withLatestFrom(myList) { selectedDate, posts in
                posts.filter { $0.title == selectedDate }
            }
            .share(replay: 1, scope: .whileConnected)
        
        let routineList = resultList
            .map { posts in
                posts.flatMap { post -> [Routines] in
                    guard let content = post.content else { return [] }
                    return content.split(separator: ";").compactMap { routine in
                        let components = routine.split(separator: "|")
                        guard components.count == 2 else { return nil }
                        
                        let bodyPart = components[0].trimmingCharacters(in: .whitespaces)
                        let routineDetails = components[1].split(separator: ",")
                        guard routineDetails.count == 4 else { return nil }
                        
                        let routineName = routineDetails[0].trimmingCharacters(in: .whitespaces)
                        let set = routineDetails[1].trimmingCharacters(in: .whitespaces)
                        let weight = routineDetails[2].trimmingCharacters(in: .whitespaces)
                        let count = routineDetails[3].trimmingCharacters(in: .whitespaces)
                        
                        return Routines(bodyPart: bodyPart, routineName: routineName, set: set, weight: weight, count: count)
                    }
                }
            }
            .share(replay: 1, scope: .whileConnected)
        
        let content1List = resultList
            .map { posts in
                posts.compactMap { post in
                    post.content1
                }
            }
        
        return Output(
            selectedSegmentIndexTap: selectedSegmentIndexTap,
            recordButtonTapped: recordButtonTapped,
            myList: myList,
            setDateList: routineList,
            content1List: content1List
        )
    }
    
    func fetchData() {
        networkManager.request(api: .profile(.myProfile), model: UserProfile.self)
            .flatMap { result -> Single<[UserProfile]> in
                switch result {
                case .success(let profile):
                    return self.networkManager.request(api: .post(.userByPostAPI(id: profile.userId, productId: "내운동기록")), model: PostViewResponse.self)
                        .flatMap { postResult -> Single<[UserProfile]> in
                            switch postResult {
                            case .success(let postResponse):
                                self.myList.onNext(postResponse.data)
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
                self.profileList.onNext(profiles)
            }, onFailure: { error in
                self.profileList.onNext([])
            })
            .disposed(by: disposeBag)
    }
}
