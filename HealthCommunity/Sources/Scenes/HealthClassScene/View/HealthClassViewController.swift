//
//  HealthClassViewController.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/23/24.
//

import UIKit
import RxSwift
import RxCocoa

final class HealthClassViewController: BaseViewController<HealthClassView> {
    
    private let viewModel = HealthClassViewModel()
    
    private let locations = ["전체", "서울", "부산", "대구", "광주", "인천", "대전"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bindModel() {
        let input = HealthClassViewModel.Input()
        
        let output = viewModel.transform(input: input)
        
        output.posts
            .bind(to: rootView.collectionView.rx.items(
                cellIdentifier: HealthClassCollectionViewCell.identifier,
                cellType: HealthClassCollectionViewCell.self)) { row, post, cell in
                    cell.configure(with: post)
                }
                .disposed(by: viewModel.disposeBag)
        
        
        
    }
    
}
