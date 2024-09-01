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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.refreshData()
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
        
        rootView.collectionView.rx.modelSelected(Post.self)
            .subscribe(with: self) { owner, post in
                let detailVC = HealthClassDetailViewController(postData: post)
                owner.navigationController?.pushViewController(detailVC, animated: true)
            }
            .disposed(by: viewModel.disposeBag)
        
    }
    
}
