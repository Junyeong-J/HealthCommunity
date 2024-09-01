//
//  CommentViewController.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/25/24.
//

import UIKit
import RxSwift
import RxCocoa

final class CommentViewController: BaseViewController<CommentView> {
    
    private let viewModel: CommentViewModel
    private var postDetail: Post
    
    init(postDetail: Post) {
        self.viewModel = CommentViewModel()
        self.postDetail = postDetail
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .pageSheet
        
        if let sheet = self.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.preferredCornerRadius = 20
            sheet.largestUndimmedDetentIdentifier = .large
        }
        
    }
    
    override func configureView() {
        super.configureView()
    }
    
    override func bindModel() {
        
        let input = CommentViewModel.Input(
            postDetail: postDetail,
            sendButtonTap: rootView.sendButton.rx.tap,
            text: rootView.commentTextField.rx.text.orEmpty)
        
        let output = viewModel.transform(input: input)
        
        output.commentData
            .drive(rootView.tableView.rx.items(
                cellIdentifier: CommentTableViewCell.identifier,
                cellType: CommentTableViewCell.self)) { _, comment, cell in
                    cell.configure(with: comment)
                }
                .disposed(by: viewModel.disposeBag)
        
        input.sendButtonTap
            .bind(with: self, onNext: { owner, _ in
                owner.rootView.commentTextField.text = ""
                owner.rootView.commentTextField.resignFirstResponder()
            })
            .disposed(by: viewModel.disposeBag)
    }
    
}
