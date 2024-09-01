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
    
    private var nextCursor: String = ""
    private var isLoad: Bool = false
    private var isMoreData: Bool = true
    
    private let appList = BehaviorRelay<[Post]>(value: [])
    
    struct Input {
        let postButtonTap: ControlEvent<Void>
        let selectedSegment: ControlProperty<Int>
        let refreshTrigger: ControlEvent<Void>
        let loadMoreTrigger: Observable<Void>
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
                guard let self = self else { return Observable.just([]) }
                self.pagination()
                return self.fetchPosts(for: index)
            }
            .do(onNext: { [weak self] _ in
                refreshLoading.accept(false)
                self?.isLoad = false
            })
            .bind(to: appList)
            .disposed(by: disposeBag)
        
        input.refreshTrigger
            .withLatestFrom(input.selectedSegment.asObservable())
            .flatMapLatest { [weak self] index -> Observable<[Post]> in
                guard let self = self else { return Observable.just([]) }
                self.pagination()
                return self.fetchPosts(for: index)
            }
            .do(onNext: { [weak self] _ in
                refreshLoading.accept(false)
                self?.isLoad = false
            })
            .bind(to: appList)
            .disposed(by: disposeBag)
        
        input.loadMoreTrigger
            .withLatestFrom(input.selectedSegment.asObservable())
            .filter { [weak self] _ in
                !(self?.isLoad ?? true) && (self?.isMoreData ?? true)
            }
            .flatMapLatest { [weak self] index -> Observable<[Post]> in
                guard let self = self else { return Observable.just([]) }
                self.isLoad = true
                return self.fetchPosts(for: index)
            }
            .do(onNext: { [weak self] newPosts in
                self?.isLoad = false
                guard let self = self else { return }
                if newPosts.isEmpty {
                    self.isMoreData = false
                } else {
                    self.appList.accept(self.appList.value + newPosts)
                }
            })
            .subscribe()
            .disposed(by: disposeBag)
        
        return Output(
            postButtonTapped: input.postButtonTap,
            selectedSegment: input.selectedSegment,
            items: appList.asObservable(),
            refreshLoading: refreshLoading.asDriver(onErrorJustReturn: false)
        )
    }
    
    private func pagination() {
        self.nextCursor = ""
        self.isMoreData = true
        self.appList.accept([])
    }
    
    private func fetchPosts(for index: Int) -> Observable<[Post]> {
        let productId: String
        
        switch index {
        case 0:
            productId = "오운완"
        case 1:
            productId = "피드백"
        case 2:
            productId = "소통"
        default:
            return Observable.just([])
        }
        
        let request = self.networkManager.request(
            api: .post(.postView(next: nextCursor, limit: "5", productId: productId)),
            model: PostViewResponse.self
        )
        
        return request
            .asObservable()
            .map { [weak self] result in
                switch result {
                case .success(let response):
                    if response.nextCursor == "0" {
                        self?.isMoreData = false
                    } else {
                        self?.nextCursor = response.nextCursor
                    }
                    return response.data
                case .failure(let error):
                    print("Error: \(error)")
                    return []
                }
            }
    }
}
