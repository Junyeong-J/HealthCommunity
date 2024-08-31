//
//  PostViewModel.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/31/24.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

final class PostViewModel: BaseViewModel {
    
    let disposeBag = DisposeBag()
    private let networkManager = LSLPAPIManager.shared
    
    struct Input {
        let onewonButtonTap: ControlEvent<Void>
        let routineData: Observable<[String: [String]]>
        let feedbackButtonTap: ControlEvent<Void>
        let communicationButtonTap: ControlEvent<Void>
        let albumButtonTap: ControlEvent<Void>
        let contentData: Observable<String>
        let healthData: Observable<String>
        let postButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let selectedButtonIndex: Driver<Int>
        let albumButtonTapped: Driver<Void>
        let photos: Driver<[UIImage]>
        let menuItems: Driver<[String]>
        let healthData: Observable<String>
        let routineList: Observable<[String: [String]]>
    }
    
    private let photosRelay = BehaviorRelay<[UIImage]>(value: [])
    
    func transform(input: Input) -> Output {
        
        let selectedIndex = Observable.of(
            input.onewonButtonTap.map { 0 },
            input.feedbackButtonTap.map { 1 },
            input.communicationButtonTap.map { 2 }
        )
            .merge()
            .asDriver(onErrorJustReturn: 0)
        
        let albumButtonTapped = input.albumButtonTap.asDriver()
        
        let menuItems = Observable.just([
            "루틴 선택",
            "건강 데이터 등록"
        ]).asDriver(onErrorJustReturn: [])
        
        input.postButtonTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(photosRelay)
            .distinctUntilChanged()
            .map { photos in
                return photos.compactMap { $0.jpegData(compressionQuality: 0.7) }
            }
            .flatMap { imageDatas in
                self.networkManager.uploadImagesRequest(model: ImageResponse.self, imageDatas: imageDatas)
                    .catch { error in
                        return Single.just(.failure(APIError.invalidRequest))
                    }
            }
            .debug("Button Tap")
            .subscribe(onNext: { result in
                switch result {
                case .success(let response):
                    print(response)
                case .failure(let error):
                    print("Error: \(error)")
                }
            })
            .disposed(by: disposeBag)
        
        
        return Output(
            selectedButtonIndex: selectedIndex,
            albumButtonTapped: albumButtonTapped,
            photos: photosRelay.asDriver(),
            menuItems: menuItems,
            healthData: input.healthData,
            routineList: input.routineData
        )
    }
    
    func addPhoto(_ photo: UIImage) {
        var photos = photosRelay.value
        if photos.count < 5 {
            photos.append(photo)
            photosRelay.accept(photos)
        }
    }
    
    func removePhoto(at index: Int) {
        var photos = photosRelay.value
        if index < photos.count {
            photos.remove(at: index)
            photosRelay.accept(photos)
        }
    }
}
