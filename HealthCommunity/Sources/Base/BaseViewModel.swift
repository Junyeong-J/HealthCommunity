//
//  BaseViewModel.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/15/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol BaseViewModel {
    
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
    
    var disposeBag: DisposeBag { get }
    
}
