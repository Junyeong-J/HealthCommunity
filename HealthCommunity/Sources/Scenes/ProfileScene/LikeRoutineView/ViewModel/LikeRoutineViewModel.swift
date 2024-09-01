//
//  LikeRoutineViewModel.swift
//  HealthCommunity
//
//  Created by 전준영 on 9/1/24.
//

import Foundation
import RxSwift
import RxCocoa

final class LikeRoutineViewModel: BaseViewModel {
    
    let disposeBag = DisposeBag()
    private let networkManager = LSLPAPIManager.shared
    private let groupedLikeList = PublishSubject<[(Creator, [RoutinDetail])]>()
    
    struct Input { }
    
    struct Output {
        let groupedLikeList: Observable<[(Creator, [RoutinDetail])]>
    }
    
    func transform(input: Input) -> Output {
        fetchLikeListData()
        return Output(groupedLikeList: groupedLikeList.asObservable())
    }
    
    private func fetchLikeListData() {
        networkManager.request(api: .post(.likeMeAPI(next: "", limit: "")), model: MeLikeResponse.self)
            .flatMap { result -> Single<[(Creator, [RoutinDetail])] > in
                switch result {
                case .success(let response):
                    let userPosts = response.data.map { post -> (Creator, [RoutinDetail]) in
                        let creator = post.creator
                        let routines = post.content?.components(separatedBy: "; ").compactMap { routineString -> RoutinDetail? in
                            return self.parseRoutineData(routineString)
                        } ?? []
                        return (creator, routines)
                    }
                    return Single.just(userPosts)
                case .failure(let error):
                    print("Error: \(error)")
                    return Single.just([])
                }
            }
            .subscribe(onSuccess: { userPosts in
                self.groupedLikeList.onNext(userPosts)
            }, onFailure: { error in
                self.groupedLikeList.onNext([])
            })
            .disposed(by: disposeBag)
    }
    
    private func parseRoutineData(_ data: String) -> RoutinDetail? {
        let details = data.components(separatedBy: ", ")
        guard details.count == 4 else { return nil }
        
        let categoryAndName = details[0].components(separatedBy: "|")
        let category = categoryAndName[0].trimmingCharacters(in: .whitespacesAndNewlines)
        let name = categoryAndName[1].trimmingCharacters(in: .whitespacesAndNewlines)
        let sets = details[1]
        let weight = details[2]
        let reps = details[3]
        
        return RoutinDetail(category: category, name: name, sets: sets, weight: weight, reps: reps)
    }
}
