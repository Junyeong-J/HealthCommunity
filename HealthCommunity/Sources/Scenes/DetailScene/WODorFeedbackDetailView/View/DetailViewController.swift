//
//  WodDetailViewController.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/25/24.
//

import UIKit
import RxSwift
import RxCocoa

final class WodDetailViewController: BaseViewController<WodDetailView> {
    
    private var postDetail: Post
    private let viewModel: WodDetailViewModel
    
    init(postDetail: Post) {
        self.viewModel = WodDetailViewModel()
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
        
        rootView.configureData(data: postDetail)
    }
    
    override func bindModel() {
        let input = WodDetailViewModel.Input(
            commentTap: rootView.showCommentsButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.commentTapped
            .bind(with: self) { owner, _ in
                let commentViewController = CommentViewController(postDetail: owner.postDetail)
                owner.present(commentViewController, animated: true, completion: nil)
            }
            .disposed(by: viewModel.disposeBag)
    }
    
}
