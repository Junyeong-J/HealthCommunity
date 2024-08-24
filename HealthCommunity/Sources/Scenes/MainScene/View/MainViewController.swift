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
            .bind(to: rootView.wodTableView.rx.items(
                cellIdentifier: MainWodTableViewCell.identifier,
                cellType: MainWodTableViewCell.self)) { row, item, cell in
                    cell.configure(post: item)
                }
                .disposed(by: viewModel.disposeBag)
        
        output.items
            .bind(to: rootView.feedbackTableView.rx.items(
                cellIdentifier: MainFeedbackTableViewCell.identifier,
                cellType: MainFeedbackTableViewCell.self)) { row, item, cell in
                    cell.configure(post: item)
                }
                .disposed(by: viewModel.disposeBag)
        
        output.items
            .bind(to: rootView.communicationTableView.rx.items(
                cellIdentifier: MainCommunityTableViewCell.identifier,
                cellType: MainCommunityTableViewCell.self)) { row, item, cell in
                    cell.configure(post: item)
                }
                .disposed(by: viewModel.disposeBag)
    }
    
}
