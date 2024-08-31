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
        let tableSize: Reactive<UITableView>
    }
    
    struct Output {
        let selectedButtonIndex: Driver<Int>
        let albumButtonTapped: Driver<Void>
        let photos: Driver<[UIImage]>
        let menuItems: Driver<[String]>
        let healthData: Observable<String>
        let routineList: Observable<[String: [String]]>
        let postResult: Driver<Bool>
        let tableSizeOutput: Observable<CGFloat>
    }
    
    private let photosRelay = BehaviorRelay<[UIImage]>(value: [])
    private let productIdRelay = BehaviorRelay<String>(value: "오운완")
    
    func transform(input: Input) -> Output {
        
        let formattedHealthData = input.healthData
            .map { healthData -> String in
                let numbers = healthData
                    .components(separatedBy: CharacterSet(charactersIn: " ,걸음km칼로리분서있기"))
                    .filter { !$0.isEmpty }
                return numbers.joined(separator: ", ")
            }
        
        let tablesize = input.tableSize
            .observe(CGSize.self, "contentSize")
            .compactMap { $0?.height }
            .distinctUntilChanged()
        
        input.onewonButtonTap
            .map { "오운완" }
            .bind(to: productIdRelay)
            .disposed(by: disposeBag)
        
        input.feedbackButtonTap
            .map { "피드백" }
            .bind(to: productIdRelay)
            .disposed(by: disposeBag)
        
        input.communicationButtonTap
            .map { "소통" }
            .bind(to: productIdRelay)
            .disposed(by: disposeBag)
        
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
        
        let postResult = input.postButtonTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(photosRelay)
            .distinctUntilChanged()
            .map { photos in
                return photos.compactMap { $0.jpegData(compressionQuality: 0.7) }
            }
            .flatMapLatest { imageDatas in
                self.networkManager.uploadImagesRequest(model: ImageResponse.self, imageDatas: imageDatas)
                    .asObservable()
            }
            .withLatestFrom(Observable.combineLatest(
                input.contentData, formattedHealthData, productIdRelay)) {
                    (uploadResult, combinedData) -> (Result<ImageResponse, APIError>, String, String, String) in
                return (uploadResult, combinedData.0, combinedData.1, combinedData.2)
            }
            .flatMapLatest { uploadResult, content, healthData, productId in
                switch uploadResult {
                case .success(let imageResponse):
                    let files = imageResponse.files
                    return self.networkManager.request(
                        api: .post(.posts(content: content, content1: healthData, content2: "", productId: productId, files: files)),
                        model: PostModelResponse.self
                    )
                    .map { result -> Bool in
                        switch result {
                        case .success(let value):
                            print("Post successful: \(value)")
                            return true
                        case .failure(let error):
                            print("Post failed: \(error)")
                            return false
                        }
                    }
                    .asObservable()
                    
                case .failure(let error):
                    print("Image upload failed: \(error)")
                    return Observable.just(false)
                }
            }
            .asDriver(onErrorJustReturn: false)
        
        return Output(
            selectedButtonIndex: selectedIndex,
            albumButtonTapped: albumButtonTapped,
            photos: photosRelay.asDriver(),
            menuItems: menuItems,
            healthData: input.healthData,
            routineList: input.routineData,
            postResult: postResult,
            tableSizeOutput: tablesize
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
