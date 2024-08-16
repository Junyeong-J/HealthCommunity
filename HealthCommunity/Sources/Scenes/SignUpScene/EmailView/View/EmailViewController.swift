//
//  EmailViewController.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/16/24.
//

import UIKit
import RxSwift
import RxCocoa
import Toast

final class EmailViewController: BaseViewController<EmailView> {
    
    private let viewModel = EmailViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        super.configureView()
    }
    
    override func bindModel() {
        let input = EmailViewModel.Input(
            emailCheckButtonTap: rootView.emailCheckButton.rx.tap,
            email: rootView.emailTextField.rx.text.orEmpty.asObservable())
        
        let output = viewModel.transform(input: input)
        
        output.emailCheckResult
            .bind(with: self, onNext: { owner, message in
                owner.view.makeToast(message)
            })
            .disposed(by: disposeBag)
            
    }
    
}
