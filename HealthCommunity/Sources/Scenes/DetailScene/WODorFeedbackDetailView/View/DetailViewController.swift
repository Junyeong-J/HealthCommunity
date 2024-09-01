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
    }
    
    override func configureView() {
        super.configureView()
    }
    
    override func bindModel() {
        let input = DetailViewModel.Input(
            commentTap: rootView.showCommentsButton.rx.tap,
            likeButtonTap: rootView.routineToggleView.actionButton.rx.tap,
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
