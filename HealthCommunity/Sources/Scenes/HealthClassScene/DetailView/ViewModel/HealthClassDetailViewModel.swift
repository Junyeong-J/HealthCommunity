//
//  HealthClassDetailViewModel.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/30/24.
//

import Foundation
import RxSwift
import RxCocoa

final class HealthClassDetailViewModel: BaseViewModel {
    
    let disposeBag = DisposeBag()
    private let networkManager = LSLPAPIManager.shared
    private let postList = PublishSubject<[Post]>()
    private let myPaymentList = PublishSubject<[PaymentResponse]>()
    
    struct Input {
        let postData: Post
    }
    
    struct Output {
        let posts: Observable<[Post]>
        let isPurchased: Observable<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        networkManager.request(api: .post(.specificPost(id: input.postData.postID)), model: Post.self)
            .flatMap { result -> Single<[Post]> in
                switch result {
                case .success(let post):
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
        
        networkManager.request(api: .payment(.myPayment), model: myPaymentResponse.self)
            .flatMap { result -> Single<[PaymentResponse]> in
                switch result {
                case .success(let paymentResponse):
                    return Single.just(paymentResponse.data)
                case .failure(let error):
                    print("Error: \(error)")
                    return Single.just([])
                }
            }
            .subscribe(with: self, onSuccess: { owner, paymentData in
                owner.myPaymentList.onNext(paymentData)
            }, onFailure: { owner, error in
                owner.myPaymentList.onNext([])
            })
            .disposed(by: disposeBag)
        
        let isPurchased = Observable.combineLatest(postList, myPaymentList)
            .map { posts, payments in
                guard let post = posts.first else { return false }
                return payments.contains { $0.postID == post.postID && post.buyers.contains($0.buyerID) }
            }
        
        return Output(posts: postList,
                      isPurchased: isPurchased)
    }
    
}
