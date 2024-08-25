//
//  WODViewModel.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/19/24.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

final class WODViewModel: BaseViewModel {
    let disposeBag = DisposeBag()
    
    struct Input {
        let albumButtonTap: ControlEvent<Void>
        let actionButtonTap: ControlEvent<Void>
        let selectedImages: Observable<[UIImage]>
    }
    
    struct Output {
        let albumButtonTapped: ControlEvent<Void>
        let tableList: Observable<[String]>
        let uploadResult: Observable<Result<ImageResponse, APIError>>
    }
    
    func transform(input: Input) -> Output {
        
        let tableList = Observable.just(WODTableTitles.allTitles)
        
        let uploadResult = input.actionButtonTap
            .withLatestFrom(input.selectedImages)
            .flatMapLatest { images in
                return LSLPAPIManager.shared
                    .upload(api: LSLPRouter.post(.imageUpload(images: images)), model: ImageResponse.self)
                    .asObservable()
            }
        
        return Output(albumButtonTapped: input.albumButtonTap, tableList: tableList, uploadResult: uploadResult)
    }
}

//모야 타겟
