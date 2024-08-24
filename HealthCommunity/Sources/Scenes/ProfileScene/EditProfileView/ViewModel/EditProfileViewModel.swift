//
//  EditProfileViewModel.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/24/24.
//

import RxSwift
import RxCocoa
import UIKit

final class EditProfileViewModel: BaseViewModel {
    
    let disposeBag = DisposeBag()
    private let networkManager = LSLPAPIManager.shared
    
    struct Input {
        let galleryButtonTap: ControlEvent<Void>
        let saveButtonTap: ControlEvent<Void>
        let nick: Observable<String>
        let introduction: Observable<String>
        let bench: Observable<String>
        let squat: Observable<String>
        let deadlift: Observable<String>
        let profileImage: Observable<UIImage?>
    }
    
    struct Output {
        let galleryButtonTapped: ControlEvent<Void>
        let saveButtonResult: Observable<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        let saveButtonResult = input.saveButtonTap
            .withLatestFrom(Observable.combineLatest(input.nick, input.introduction, input.bench, input.squat, input.deadlift, input.profileImage))
            .flatMapLatest { [weak self] nick, introduction, bench, squat, deadlift, profileImage -> Observable<Bool> in
                guard let self = self else { return Observable.just(false) }
                
                return self.networkManager.uploadRequest(
                    nick: nick,
                    introduction: introduction,
                    bench: bench,
                    squat: squat,
                    deadlift: deadlift,
                    model: UserProfile.self,
                    imageData: profileImage?.pngData()
                )
                .map { result -> Bool in
                    switch result {
                    case .success:
                        return true
                    case .failure(let error):
                        print("Error: \(error)")
                        return false
                    }
                }
                .asObservable()
            }
            .share(replay: 1)
        
        return Output(galleryButtonTapped: input.galleryButtonTap, saveButtonResult: saveButtonResult)
    }
}

