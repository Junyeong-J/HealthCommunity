//
//  DetailViewModel.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/25/24.
//

import Foundation
import RxSwift
import RxCocoa

final class DetailViewModel: BaseViewModel {
    
    let disposeBag = DisposeBag()
    private let networkManager = LSLPAPIManager.shared
    
    private let postList = PublishSubject<[Post]>()
    private let likeStatusRelay = BehaviorRelay<Bool>(value: false)
    private let postDeleted = PublishSubject<Void>()
    
    struct Input {
        let commentTap: ControlEvent<Void>
        let likeButtonTap: ControlEvent<Void>
        let deleteButtonTap: Observable<Void>
        let post: Post
    }
    
    struct Output {
        let commentTapped: ControlEvent<Void>
        let posts: Observable<[Post]>
        let likeStatus: Driver<Bool>
        let postDeleted: Observable<Void>
    }
    
    func transform(input: Input) -> Output {
        
        input.likeButtonTap
            .withLatestFrom(likeStatusRelay)
            .flatMapLatest { [weak self] currentStatus in
                self?.toggleLikeStatus(userID: input.post.postID, currentStatus: currentStatus) ?? .empty()
            }
            .bind(to: likeStatusRelay)
            .disposed(by: disposeBag)
        
        networkManager.request(api: .post(.specificPost(id: input.post.postID)), model: Post.self)
            .flatMap { result -> Single<[Post]> in
                switch result {
                case .success(let post):
                    let userID = UserDefaultsManager.shared.userID
                    if post.likes.contains(userID) {
                        self.likeStatusRelay.accept(true)
                    } else {
                        self.likeStatusRelay.accept(false)
                    }
                    return Single.just([post])
                case .failure(let error):
                    print("Error: \(error)")
                    return Single.just([])
                }
            }
            .subscribe(with: self, onSuccess: { owner, postData in
                owner.postList.onNext(postData)
            }, onFailure: { owner, error in
                owner.postList.onNext([])
            })
            .disposed(by: disposeBag)
        
        input.deleteButtonTap
            .flatMapLatest { [weak self] in
                self?.deletePost(postID: input.post.postID) ?? .empty()
            }
            .bind(to: postDeleted)
            .disposed(by: disposeBag)
        
        return Output(commentTapped: input.commentTap,
                      posts: postList,
                      likeStatus: likeStatusRelay.asDriver(onErrorJustReturn: false),
                      postDeleted: postDeleted.asObservable())
    }
    
    private func toggleLikeStatus(userID: String, currentStatus: Bool) -> Observable<Bool> {
        let newStatus = !currentStatus
        return networkManager.request(api: .post(.likeAPI(id: userID, likeState: newStatus)), model: likeResponse.self)
            .asObservable()
            .map { result in
                switch result {
                case .success(let response):
                    return response.likeStaus
                case .failure:
                    return currentStatus
                }
            }
            .catchAndReturn(currentStatus)
    }
    
    private func deletePost(postID: String) -> Observable<Void> {
        return networkManager.request(api: .post(.deletePost(id: postID)), model: Data.self)
            .asObservable()
            .map { result in
                switch result {
                case .success:
                    return ()
                case .failure(let error):
                    print("Error: \(error)")
                    throw error
                }
            }
    }
    
}
