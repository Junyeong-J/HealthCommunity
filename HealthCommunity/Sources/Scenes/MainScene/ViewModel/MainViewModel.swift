//
//  MainViewModel.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/19/24.
//

import Foundation
import RxSwift
import RxCocoa

final class MainViewModel: BaseViewModel {
    
    let disposeBag = DisposeBag()
    
    private let networkManager = LSLPAPIManager.shared
    private var isLoad = true
    
    private let appList = PublishSubject<[Post]>()
    
    struct Input {
        let postButtonTap: ControlEvent<Void>
        let selectedSegment: ControlProperty<Int>
        let refreshTrigger: ControlEvent<Void>
    }
    
    struct Output {
        let postButtonTapped: ControlEvent<Void>
        let selectedSegment: ControlProperty<Int>
        let items: Observable<[Post]>
        let refreshLoading: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        let refreshLoading = PublishRelay<Bool>()
        
        networkManager.request(api: .profile(.myProfile), model: UserProfile.self)
            .flatMap { result -> Single<Void> in
                switch result {
                case .success(let profile):
                    let userID = profile.userId
                    UserDefaultsManager.shared.userID = userID
                    return Single.just(())
                case .failure(let error):
                    print("Error: \(error)")
                    return Single.just(())
                }
            }
            .subscribe()
            .disposed(by: disposeBag)
        
        input.selectedSegment
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest { [weak self] index -> Observable<[Post]> in
                return self?.fetchPosts(for: index) ?? Observable.just([])
            }
            .bind(to: appList)
            .disposed(by: disposeBag)
        
        //        input.refreshTrigger
        //            .withLatestFrom(input.selectedSegment.asObservable())
        //            .flatMapLatest { [weak self] index -> Observable<[Post]> in
        //                return self?.fetchPosts(for: index) ?? Observable.just([])
        //            }
        //            .do(onNext: { _ in
        //                refreshLoading.accept(false)
        //            })
        //            .bind(to: appList)
        //            .disposed(by: disposeBag)
        
        return Output(
            postButtonTapped: input.postButtonTap,
            selectedSegment: input.selectedSegment,
            items: appList,
            refreshLoading: refreshLoading.asDriver(onErrorJustReturn: false)
        )
    }
}


extension MainViewModel {
    
    func refreshCurrentSegment(_ index: Int) {
        fetchPosts(for: index)
            .bind(to: appList)
            .disposed(by: disposeBag)
    }
    
    private func fetchPosts(for index: Int) -> Observable<[Post]> {
        let request: Single<Result<PostViewResponse, APIError>>
        
        switch index {
        case 0:
            request = self.networkManager.request(
                api: .post(.postView(next: "", limit: "5", productId: "오운완")),
                model: PostViewResponse.self
            )
        case 1:
            request = self.networkManager.request(
                api: .post(.postView(next: "", limit: "5", productId: "피드백")),
                model: PostViewResponse.self
            )
        case 2:
            request = self.networkManager.request(
                api: .post(.postView(next: "", limit: "5", productId: "소통")),
                model: PostViewResponse.self
            )
        default:
            return Observable.just([])
        }
        
        return request
            .asObservable()
            .map { result in
                switch result {
                case .success(let response):
                    return response.data
                case .failure(let error):
                    print("Error: \(error)")
                    return []
                }
            }
    }
    
}
