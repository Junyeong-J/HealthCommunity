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
            emailCheckButtonTap: rootView.checkEmailButton.rx.tap,
            email: rootView.emailTextField.rx.text.orEmpty.asObservable(),
            nextButtonTap: rootView.nextButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        output.emailCheckResult
            .bind(with: self, onNext: { owner, message in
                owner.view.makeToast(message)
            })
            .disposed(by: disposeBag)
            
        output.isEmail
            .bind(with: self) { owner, value in
                owner.rootView.nextButton.isEnabled = value
                owner.rootView.nextButton.backgroundColor = value ? .myAppMain : .myAppGray
            }
            .disposed(by: disposeBag)
        
        output.nextButtonTapped
            .withLatestFrom(output.isEmail)
            .filter { $0 }
            .withLatestFrom(output.email)
            .bind(with: self) { owner, value in
                let passwordVC = PasswordViewController(email: value)
                owner.navigationController?.pushViewController(passwordVC, animated: true)
            }
            .disposed(by: disposeBag)
        
    }
    
    
    
}
