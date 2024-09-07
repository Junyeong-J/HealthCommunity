//
//  DetailViewController.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/25/24.
//

import UIKit
import RxSwift
import RxCocoa

final class DetailViewController: BaseViewController<DetailView> {
    
    private var postDetail: Post
    private let viewModel: DetailViewModel
    private let deleteButtonTap = PublishSubject<Void>()
    
    init(postDetail: Post) {
        self.viewModel = DetailViewModel()
        self.postDetail = postDetail
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
    
    override func configureView() {
        super.configureView()
    }
    
    override func bindModel() {
        let input = DetailViewModel.Input(
            commentTap: rootView.showCommentsButton.rx.tap,
            likeButtonTap: rootView.routineToggleView.actionButton.rx.tap,
            deleteButtonTap: deleteButtonTap.asObserver(),
            post: postDetail)
        let output = viewModel.transform(input: input)
        
        output.posts
            .bind(with: self, onNext: { owner, post in
                owner.rootView.configureData(data: post)
            })
            .disposed(by: viewModel.disposeBag)
        
        output.likeStatus
            .drive(with: self, onNext: { owner, isLiked in
                let imageName = isLiked ? "heart.fill" : "heart"
                owner.rootView.routineToggleView.actionButton.setImage(UIImage(systemName: imageName), for: .normal)
            })
            .disposed(by: viewModel.disposeBag)
        
        output.commentTapped
            .bind(with: self) { owner, _ in
                let commentViewController = CommentViewController(postDetail: owner.postDetail)
                owner.present(commentViewController, animated: true, completion: nil)
            }
            .disposed(by: viewModel.disposeBag)
    }
    
}

extension DetailViewController {
    
    private func setupNavigationBar() {
        let image = UIImage(systemName: "ellipsis")
        let menuButton = UIBarButtonItem(image: image, style: .plain, target: nil, action: nil)
        
        self.navigationItem.rightBarButtonItem = menuButton
        
        menuButton.rx.tap
            .bind(with: self, onNext: { owner, _ in
                owner.showActionSheet()
            })
            .disposed(by: viewModel.disposeBag)
    }
    
    private func showActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let edit = UIAlertAction(title: "수정하기", style: .default) { _ in
            print("수정")
        }
        
        let delete = UIAlertAction(title: "삭제하기", style: .destructive) { [weak self] _ in
            self?.deleteButtonTap.onNext(())
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        actionSheet.addAction(edit)
        actionSheet.addAction(delete)
        actionSheet.addAction(cancel)
        
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.barButtonItem = self.navigationItem.rightBarButtonItem
        }
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
}
