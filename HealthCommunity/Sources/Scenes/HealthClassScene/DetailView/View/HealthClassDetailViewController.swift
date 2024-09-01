//
//  HealthClassDetailViewController.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/30/24.
//

import UIKit
import RxSwift
import RxCocoa

final class HealthClassDetailViewController: BaseViewController<HealthClassDetailView> {
    
    private let postData: Post
    private let viewModel = HealthClassDetailViewModel()
    
    init(postData: Post) {
        self.postData = postData
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindModel()
        setupNotification()
    }
    
    private func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: Notification.Name("paymentCompleted"), object: nil)
    }
    
    @objc private func refreshData() {
        bindModel()
    }
    
    override func bindModel() {
        let input = HealthClassDetailViewModel.Input(postData: postData)
        
        let output = viewModel.transform(input: input)
        
        output.posts
            .compactMap { $0.first }
            .bind(with: self) { owner, post in
                owner.rootView.updateView(post: post)
            }
            .disposed(by: viewModel.disposeBag)
        
        Observable.combineLatest(output.posts.compactMap { $0.first }, output.isPurchased)
            .bind(with: self) { owner, combinedData in
                let (post, isPurchased) = combinedData
                
                if isPurchased {
                    owner.rootView.updateButton()
                } else {
                    owner.rootView.actionButton.rx.tap
                        .bind(with: owner) { owner, _ in
                            let paymentVC = PaymentViewController(
                                postID: owner.postData.postID,
                                paymentAmount: "\(post.price ?? 0)",
                                paymentTitle: post.title ?? "상품 이름 없음"
                            )
                            paymentVC.modalPresentationStyle = .pageSheet
                            owner.present(paymentVC, animated: true)
                        }
                        .disposed(by: owner.viewModel.disposeBag)
                }
            }
            .disposed(by: viewModel.disposeBag)
    }
}

