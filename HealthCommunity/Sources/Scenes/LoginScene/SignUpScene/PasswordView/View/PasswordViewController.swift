//
//  PasswordViewController.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/17/24.
//

import UIKit
import RxSwift
import RxCocoa

final class PasswordViewController: BaseViewController<PasswordView> {
    
    private let viewModel: PasswordViewModel
    private let disposeBag = DisposeBag()
    
    init(email: String) {
        self.viewModel = PasswordViewModel()
        self.viewModel.email.accept(email)
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
        let input = PasswordViewModel.Input(
            passwordText: rootView.passwordInputTextField.rx.text,
            password: rootView.passwordInputTextField.rx.text.orEmpty.asObservable(),
            nextButtonTap: rootView.passwordNextbt.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        let requirements: [(Observable<Bool>, Int)] = [
            (output.isNumber, 0),
            (output.isSpecialCharacter, 1),
            (output.isLowercase, 2),
            (output.isLengthValid, 3),
            (output.isWhitespace, 4)
        ]
        
        for (requirement, index) in requirements {
            requirement
                .bind(with: self, onNext: { owner, value in
                    let checkImage = owner.rootView.explainStackViews[index].arrangedSubviews[0] as? UIImageView
                    let label = owner.rootView.explainStackViews[index].arrangedSubviews[1] as? UILabel
                    checkImage?.tintColor = value ? .myAppMain : .myAppGray
                    label?.textColor = value ? .myAppBlack : .myAppGray
                })
                .disposed(by: disposeBag)
        }
        
        output.isValidPassword
            .bind(with: self) { owner, isValid in
                owner.rootView.passwordNextbt.isEnabled = isValid
                owner.rootView.passwordNextbt.backgroundColor = isValid ? .myAppMain : .myAppGray
            }
            .disposed(by: disposeBag)
        
        output.nextButtonTapped
            .withLatestFrom(Observable.combineLatest(output.password, output.email))
            .bind(with: self) { owner, value in
                let nickVC = NicknameViewController(email: value.1, password: value.0)
                owner.navigationController?.pushViewController(nickVC, animated: true)
            }
            .disposed(by: disposeBag)
    }
}
