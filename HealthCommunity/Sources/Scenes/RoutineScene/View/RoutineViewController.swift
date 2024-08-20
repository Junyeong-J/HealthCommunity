//
//  RoutineViewController.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/21/24.
//

import UIKit
import RxSwift
import RxCocoa

final class RoutineViewController: BaseViewController<RoutineView> {
    
    private let viewModel = RoutineViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        super.configureView()
    }
    
    override func bindModel() {
        let input = RoutineViewModel.Input()
        
        let output = viewModel.transform(input: input)
        
        output.routineItems
            .bind(to: rootView.collectionView.rx.items(
                cellIdentifier: RoutineCollectionViewCell.identifier,
                cellType: RoutineCollectionViewCell.self)) { (row, element, cell) in
                    cell.configure(with: element)
                }
                .disposed(by: viewModel.disposeBag)
        
        output.tableItems
            .bind(to: rootView.tableView.rx.items(
                cellIdentifier: RoutineTableViewCell.identifier,
                cellType: RoutineTableViewCell.self)) { (row, element, cell) in
                    cell.configureData(title: element)
                }
                .disposed(by: viewModel.disposeBag)
    }
}
