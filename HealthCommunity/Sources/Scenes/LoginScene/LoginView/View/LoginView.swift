//
//  LoginView.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/17/24.
//

import UIKit
import SnapKit

final class LoginView: BaseView {
    
    private let appNameLabel: UILabel = {
        let label = UILabel()
        label.text = "웨이트하우스"
        label.font = Font.bold25
        label.textAlignment = .center
        return label
    }()
    
    let emailTextField = BoxTypeTextField(style: .email)
    
    let passwordTextField: BoxTypeTextField = {
        let tf = BoxTypeTextField(style: .password)
        tf.isSecureTextEntry = true
        return tf
    }()
    
    let joinButton: UIButton = {
        let bt = UIButton()
        bt.setTitle("회원가입", for: .normal)
        bt.setTitleColor(.myAppBlack, for: .normal)
        bt.backgroundColor = .clear
        return bt
    }()
    
    let passwordSecureButton = PasswordSecureButton()
    
    let loginButton = BaseButton(title: .login)
    
    override func configureHierarchy() {
        [appNameLabel, emailTextField,
         passwordTextField, passwordSecureButton,
         joinButton, loginButton].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        
        let topOffset = UIScreen.main.bounds.height * 0.2
        
        appNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(topOffset)
            make.centerX.equalToSuperview()
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(appNameLabel.snp.bottom).offset(100)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        passwordSecureButton.snp.makeConstraints { make in
            make.trailing.equalTo(passwordTextField).inset(8)
            make.centerY.equalTo(passwordTextField)
        }
        
        joinButton.snp.makeConstraints { make in
            make.trailing.equalTo(passwordTextField).inset(10)
            make.top.equalTo(passwordTextField.snp.bottom).offset(10)
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(joinButton.snp.bottom).offset(40)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }
    
}
