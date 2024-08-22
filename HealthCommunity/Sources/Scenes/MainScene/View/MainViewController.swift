//
//  MainViewController.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/18/24.
//

import UIKit
import RxSwift
import RxCocoa

final class MainViewController: BaseViewController<MainView> {
    
    private let viewModel = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bindModel() {
        let input = MainViewModel.Input(
            postButtonTap: rootView.postButton.rx.tap,
            selectedSegment: rootView.segmentControl.rx.selectedSegmentIndex
        )
        
        let output = viewModel.transform(input: input)
        
        output.postButtonTapped
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(WODViewController(), animated: true)
            }
            .disposed(by: viewModel.disposeBag)
        
        output.selectedSegment
            .bind(with: self) { owner, index in
                owner.rootView.updateSegmentTableView(index: index)
            }
            .disposed(by: viewModel.disposeBag)
        
        output.items
            .drive(rootView.wodTableView.rx.items(
                cellIdentifier: MainTableViewCell.identifier,
                cellType: MainTableViewCell.self)) { row, item, cell in
                    cell.textLabel?.text = item
                }
                .disposed(by: viewModel.disposeBag)
        
        output.items
            .drive(rootView.feedbackTableView.rx.items(
                cellIdentifier: MainTableViewCell.identifier,
                cellType: MainTableViewCell.self)) { row, item, cell in
                    cell.textLabel?.text = item
                }
                .disposed(by: viewModel.disposeBag)
        
        output.items
            .drive(rootView.communicationTableView.rx.items(
                cellIdentifier: MainTableViewCell.identifier,
                cellType: MainTableViewCell.self)) { row, item, cell in
                    cell.textLabel?.text = item
                    cell.configureData()
                }
                .disposed(by: viewModel.disposeBag)
    }
    
}
