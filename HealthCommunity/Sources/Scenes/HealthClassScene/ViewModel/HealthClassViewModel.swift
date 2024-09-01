//
//  HealthClassViewModel.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/30/24.
//

import Foundation
import RxSwift
import RxCocoa

final class HealthClassViewModel: BaseViewModel {
    
    let disposeBag = DisposeBag()
    private let networkManager = LSLPAPIManager.shared
    private let postList = PublishSubject<[Post]>()
    
    struct Input {
        
    }
    
    struct Output {
        let posts: Observable<[Post]>
    }
    
    func transform(input: Input) -> Output {
        
        return Output(posts: postList)
    }
    
}

extension HealthClassViewModel {
    
    func refreshData() {
        networkManager.request(api: .post(.postView(next: "", limit: "", productId: "헬스PT클래스")), model: PostViewResponse.self)
            .flatMap { result -> Single<[Post]> in
                switch result {
                case .success(let post):
                    return Single.just(post.data)
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
    }
    
}
