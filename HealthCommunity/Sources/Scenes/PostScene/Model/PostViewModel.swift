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
        let contentText: Observable<String>
        let workoutTimeText: Observable<String>
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
        
        let workoutTimeViewVisible = Observable.of(
            input.onewonButtonTap.map { true },
            input.feedbackButtonTap.map { true },
            input.communicationButtonTap.map { false }
        )
            .merge()
            .asDriver(onErrorJustReturn: false)
        
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
            .withLatestFrom(Observable.combineLatest(
                photosRelay, productIdRelay, input.contentData, formattedHealthData, input.contentText, input.workoutTimeText
            ))
            .flatMapLatest { photos, productId, content, healthData, contentText, workoutTime -> Observable<Bool> in
                
                let kcalValue = self.extractKcal(from: healthData)
                let totalKcal = self.calculateTotalKcal(kcal: kcalValue, workoutTime: workoutTime)
                
                let content3 = workoutTime
                let content4 = "\(totalKcal)"
                
                if productId == "소통" {
                    return self.networkManager.request(
                        api: .post(.posts(content: "", content1: "", content2: contentText, content3: content3, content4: content4, productId: productId, files: nil)),
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
                } else {
                    let imageDatas = photos.compactMap { $0.jpegData(compressionQuality: 0.7) }
                    return self.networkManager.uploadImagesRequest(model: ImageResponse.self, imageDatas: imageDatas)
                        .asObservable()
                        .flatMapLatest { uploadResult -> Observable<Bool> in
                            switch uploadResult {
                            case .success(let imageResponse):
                                let files = imageResponse.files
                                return self.networkManager.request(
                                    api: .post(.posts(content: content, content1: healthData, content2: contentText, content3: content3, content4: content4, productId: productId, files: files)),
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
    
    private func extractKcal(from healthData: String) -> Int {
        let kcalString = healthData.split(separator: ",").compactMap { item -> Int? in
            if item.contains("칼로리") {
                return Int(item.replacingOccurrences(of: "칼로리", with: "").trimmingCharacters(in: .whitespaces))
            }
            return nil
        }.first
        return kcalString ?? 0
    }
    
    private func calculateTotalKcal(kcal: Int, workoutTime: String) -> Int {
        guard let workoutTimeInt = Int(workoutTime) else { return kcal }
        let additionalKcal = workoutTimeInt * 6
        return kcal + additionalKcal
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


