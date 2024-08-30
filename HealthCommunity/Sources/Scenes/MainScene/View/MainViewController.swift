//
//  MainViewController.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/18/24.
//

import UIKit
import RxSwift
import RxCocoa
import JGProgressHUD

final class MainViewController: BaseViewController<MainView> {
    
    private let viewModel = MainViewModel()
    
//    lazy var hud: JGProgressHUD = {
//        let loader = JGProgressHUD(style: .dark)
//        return loader
//    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        super.configureView()
        rootView.communicationTableView
            .rx.setDelegate(self)
            .disposed(by: viewModel.disposeBag)
        
        rootView.wodTableView
            .rx.setDelegate(self)
            .disposed(by: viewModel.disposeBag)
        
        rootView.feedbackTableView
            .rx.setDelegate(self)
            .disposed(by: viewModel.disposeBag)
        
        rootView.wodTableView.refreshControl = rootView.refreshControl
        rootView.feedbackTableView.refreshControl = rootView.refreshControl
        rootView.communicationTableView.refreshControl = rootView.refreshControl
        
        Observable.merge(
            rootView.wodTableView.rx.contentOffset.map { $0.y },
            rootView.feedbackTableView.rx.contentOffset.map { $0.y },
            rootView.communicationTableView.rx.contentOffset.map { $0.y }
        )
        .bind(with: self) { owner, offset in
            owner.rootView.adjustButtonShape(forScrollOffset: offset)
        }
        .disposed(by: viewModel.disposeBag)
        
    }
    
    override func bindModel() {
        let input = MainViewModel.Input(
            postButtonTap: rootView.postButton.rx.tap,
            selectedSegment: rootView.segmentControl.rx.selectedSegmentIndex,
            refreshTrigger: rootView.refreshControl.rx.controlEvent(.valueChanged)
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
        
//        output.refreshLoading
//            .drive(onNext: { [weak self] isLoading in
//                guard let self = self else { return }
//                if isLoading {
//                    self.showLoading()
//                } else {
//                    self.hideLoading()
//                    self.rootView.refreshControl.endRefreshing()
//                }
//            })
//            .disposed(by: viewModel.disposeBag)
        
        Observable.zip(
            rootView.wodTableView.rx.modelSelected(Post.self),
            rootView.wodTableView.rx.itemSelected
        )
        .bind(with: self, onNext: { owner, data in
            let (postDetail, indexPath) = data
            let wodVC = DetailViewController(postDetail: postDetail)
            owner.navigationController?.pushViewController(wodVC, animated: true)
            owner.rootView.wodTableView.deselectRow(at: indexPath, animated: true)
        })
        .disposed(by: viewModel.disposeBag)
        
        Observable.zip(
            rootView.feedbackTableView.rx.modelSelected(Post.self),
            rootView.feedbackTableView.rx.itemSelected
        )
        .bind(with: self, onNext: { owner, data in
            let (postDetail, indexPath) = data
            let wodVC = DetailViewController(postDetail: postDetail)
            owner.navigationController?.pushViewController(wodVC, animated: true)
            owner.rootView.feedbackTableView.deselectRow(at: indexPath, animated: true)
        })
        .disposed(by: viewModel.disposeBag)
        
        Observable.zip(
            rootView.communicationTableView.rx.modelSelected(Post.self),
            rootView.communicationTableView.rx.itemSelected
        )
        .bind(with: self, onNext: { owner, data in
            let (postDetail, indexPath) = data
            let wodVC = DetailViewController(postDetail: postDetail)
            owner.navigationController?.pushViewController(wodVC, animated: true)
            owner.rootView.communicationTableView.deselectRow(at: indexPath, animated: true)
        })
        .disposed(by: viewModel.disposeBag)
        
    }
    
    
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let post = try? tableView.rx.model(at: indexPath) as Post else {
            return 180
        }
        
        return post.files.isEmpty ? 180 : 400
    }
}
