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
    private var profileDataArray: [String] = []
    
    struct Input {
        let galleryButtonTap: ControlEvent<Void>
        let saveButtonTap: ControlEvent<Void>
        let nick: Observable<String>
        let introduction: Observable<String>
        let bench: Observable<String>
        let squat: Observable<String>
        let deadlift: Observable<String>
        let profileImage: Observable<UIImage?>
        let originProfileData: Observable<UserProfile>
    }
    
    struct Output {
        let galleryButtonTapped: ControlEvent<Void>
        let saveButtonResult: Observable<Bool>
        let originProfileData: Observable<UserProfile>
    }
    
    func transform(input: Input) -> Output {
        
        input.originProfileData
            .bind(with: self, onNext: { owner, profile in
                let infoString = profile.birthDay ?? ""
                let components = infoString.components(separatedBy: " ")
                
                var benchValue: String = ""
                var squatValue: String = ""
                var deadliftValue: String = ""
                
                if components.count > 1 {
                    benchValue = components[1]
                        .replacingOccurrences(of: "벤치:", with: "")
                        .replacingOccurrences(of: "kg", with: "")
                        .trimmingCharacters(in: .whitespaces)
                }
                
                if components.count > 3 {
                    squatValue = components[3]
                        .replacingOccurrences(of: "스쿼트:", with: "")
                        .replacingOccurrences(of: "kg", with: "")
                        .trimmingCharacters(in: .whitespaces)
                }
                
                if components.count > 5 {
                    deadliftValue = components[5]
                        .replacingOccurrences(of: "데드:", with: "")
                        .replacingOccurrences(of: "kg", with: "")
                        .trimmingCharacters(in: .whitespaces)
                }
                owner.profileDataArray = [profile.phoneNum ?? "",
                                         benchValue,
                                         squatValue,
                                         deadliftValue]
            })
            .disposed(by: disposeBag)
        
        Observable.combineLatest(input.introduction, input.bench, input.squat, input.deadlift)
            .bind(with: self, onNext: { owner, data in
                let newIntroduction = data.0.isEmpty ? owner.profileDataArray[0] : data.0
                let newBench = data.1.isEmpty ? owner.profileDataArray[1] : data.1
                let newSquat = data.2.isEmpty ? owner.profileDataArray[2] : data.2
                let newDeadlift = data.3.isEmpty ? owner.profileDataArray[3] : data.3
                owner.profileDataArray = [newIntroduction, newBench, newSquat, newDeadlift]
            })
            .disposed(by: disposeBag)
        
        let saveButtonResult = input.saveButtonTap
            .withLatestFrom(Observable.combineLatest(input.nick, input.profileImage))
            .flatMapLatest { [weak self] nick, profileImage -> Observable<Bool> in
                guard let self = self else { return Observable.just(false) }
                let introduction = self.profileDataArray[0]
                let bench = self.profileDataArray[1]
                let squat = self.profileDataArray[2]
                let deadlift = self.profileDataArray[3]
                return self.networkManager.uploadProfileRequest(
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
        
        return Output(galleryButtonTapped: input.galleryButtonTap,
                      saveButtonResult: saveButtonResult,
                      originProfileData: input.originProfileData)
    }
}

