//
//  LoginViewController.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/17/24.
//

import UIKit
import RxSwift
import RxCocoa
import Toast

final class LoginViewController: BaseViewController<LoginView> {
    
    private var isShowToast = false
    private let viewModel = LoginViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        NotificationCenter.default.addObserver(self, selector: #selector(showSignupSuccessToast), name: NSNotification.Name(rawValue: "signupSuccess"), object: nil)
    }
    
    override func configureView() {
        super.configureView()
    }
    
    override func bindModel() {
        let input = LoginViewModel.Input(
            loginButtonTap: rootView.loginButton.rx.tap,
            email: rootView.emailTextField.rx.text.orEmpty.asObservable(),
            password: rootView.passwordTextField.rx.text.orEmpty.asObservable(),
            joinButtonTap: rootView.joinButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        output.joinButtonTapped
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(EmailViewController(), animated: true)
            }
            .disposed(by: disposeBag)
    }
    
}
