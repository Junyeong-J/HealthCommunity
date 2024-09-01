//
//  CommentViewModel.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/25/24.
//

import Foundation
import RxSwift
import RxCocoa

final class CommentViewModel: BaseViewModel {
    
    let disposeBag = DisposeBag()
    private let networkManager = LSLPAPIManager.shared
    
    struct Input {
        let postDetail: Post
        let sendButtonTap: ControlEvent<Void>
        let text: ControlProperty<String>
    }
    
    struct Output {
        let commentData: Driver<[Comment]>
    }
    
    func transform(input: Input) -> Output {
        let commentRelay = BehaviorRelay<[Comment]>(value: input.postDetail.comments)
        
        networkManager.request(api: .post(.specificPost(id: input.postDetail.postID)), model: Post.self)
            .flatMap { result -> Single<Post> in
                switch result {
                case .success(let profile):
                    return Single.just(profile)
                case .failure(let error):
                    print("Error: \(error)")
                    return Single.just(Post(postID: "", productID: "", title: "", price: 0, content: "", content1: "", content2: "", content3: "", content4: "", createdAt: "", creator: Creator(userID: "", nick: "", profileImage: ""), files: [], likes: [], likes2: [], hashTags: [], comments: []))
                }
            }
            .subscribe(onSuccess: { data in
                commentRelay.accept(data.comments)
            }, onFailure: { error in
                commentRelay.accept([])
            })
            .disposed(by: disposeBag)
        
        input.sendButtonTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.text)
            .distinctUntilChanged()
            .filter{ !$0.isEmpty }
            .flatMap { comment in
                self.networkManager.request(api: .comment(.commentPost(id: input.postDetail.postID, content: comment)), model: Comment.self)
                    .catch { error in
                        return Single.just(.failure(APIError.invalidRequest))
                    }
            }
            .debug("Button Tap")
            .subscribe(onNext: { result in
                switch result {
                case .success(let response):
                    var currentComments = commentRelay.value
                    currentComments.insert(response, at: 0)
                    commentRelay.accept(currentComments)
                case .failure(let error):
                    print("Error: \(error)")
                }
            })
            .disposed(by: disposeBag)
        
        return Output(commentData: commentRelay.asDriver())
    }
    
}
