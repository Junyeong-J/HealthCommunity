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
    
    
    struct Input {
        let postButtonTap: ControlEvent<Void>
        let selectedSegment: ControlProperty<Int>
    }
    
    struct Output {
        let postButtonTapped: ControlEvent<Void>
        let selectedSegment: ControlProperty<Int>
        let items: Observable<[Post]>
    }
    
    func transform(input: Input) -> Output {
        let appList = PublishSubject<[Post]>()
        
        input.selectedSegment
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest { [weak self] index -> Observable<[Post]> in
                guard let self = self else {
                    return Observable.just([])
                }
                
                let request: Single<Result<PostViewResponse, APIError>>
                
                switch index {
                case 0:
                    request = self.networkManager.request(
                        api: .post(.postView(next: "", limit: "5", productId: "오운완")),
                        model: PostViewResponse.self
                    )
                case 1:
                    request = self.networkManager.request(
                        api: .post(.postView(next: "", limit: "5", productId: "피드벡")),
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
            .bind(to: appList)
            .disposed(by: disposeBag)
        
        return Output(
            postButtonTapped: input.postButtonTap,
            selectedSegment: input.selectedSegment,
            items: appList
        )
    }
}
