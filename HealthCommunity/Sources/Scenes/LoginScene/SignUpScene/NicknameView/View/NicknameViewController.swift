//
//  NicknameViewController.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/17/24.
//

import UIKit
import RxSwift
import RxCocoa
import Toast

final class NicknameViewController: BaseViewController<NicknameView> {
    
    private let viewModel: NicknameViewModel
    private let disposeBag = DisposeBag()
    
    init(email: String, password: String) {
        self.viewModel = NicknameViewModel()
        self.viewModel.email.accept(email)
        self.viewModel.password.accept(password)
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
        let input = NicknameViewModel.Input(
            nicknameText: rootView.nicknameInputTextField.rx.text,
            joinCompleteTap: rootView.joinCompletebt.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        output.isButtonEnabled
            .drive(rootView.joinCompletebt.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.isButtonEnabled
            .map { $0 ? .myAppMain : .myAppGray }
            .drive(rootView.joinCompletebt.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        output.joinResult
            .bind(with: self, onNext: { owner, value in
                if value.success {
                    let loginVC = LoginViewController()
                    let userInfo = ["message": value.message]
                    NotificationManager.shared.post(NotificationManager.Names.signupSuccess, userInfo: userInfo)
                    let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                    let sceneDelegate = windowScene?.delegate as? SceneDelegate
                    
                    let rootViewController = LoginViewController()
                    sceneDelegate?.window?.rootViewController = rootViewController
                    sceneDelegate?.window?.makeKeyAndVisible()
                } else {
                    owner.view.makeToast(value.message)
                }
            })
            .disposed(by: disposeBag)
    }
    
}
