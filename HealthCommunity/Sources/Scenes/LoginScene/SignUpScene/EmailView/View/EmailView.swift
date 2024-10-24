//
//  EmailView.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/16/24.
//

import UIKit
import SnapKit

final class EmailView: BaseView {
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "이메일 주소"
        label.font = Font.bold20
        return label
    }()
    
    private let emailImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "envelope.fill")?.withTintColor(.black, renderingMode: .alwaysOriginal))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var emailStackView: UIStackView = {
        let stview = UIStackView(arrangedSubviews: [emailImage, emailLabel])
        stview.spacing = 5
        stview.axis = .horizontal
        stview.alignment = .fill
        return stview
    }()
    
    let emailTextField : LineTextField = {
        let tf = LineTextField(style: .email)
        tf.keyboardType = .emailAddress
        return tf
    }()
    
    private let explanationLabel: UILabel = {
        let label = UILabel()
        label.text = "반드시 이메일 형식에 맞게 입력해 주세요"
        label.font = Font.bold15
        label.textColor = .myAppBlack
        return label
    }()
    
    let checkEmailButton: UIButton = {
        let button = UIButton()
        button.setTitle("중복 체크", for: .normal)
        button.titleLabel?.font = Font.bold15
        button.setTitleColor(.myAppBlack, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.myAppBlack.cgColor
        button.layer.cornerRadius = 10
        return button
    }()
    
    var nextButton = BaseButton(title: .next)
    
    override func configureHierarchy() {
        
        [checkEmailButton, emailTextField, emailStackView,
         explanationLabel, nextButton].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        
        let topOffset = UIScreen.main.bounds.height * 0.3
        
        checkEmailButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide.snp.top).offset(topOffset)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(20)
            make.width.equalTo(60)
            make.height.equalTo(44)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.bottom.equalTo(checkEmailButton)
            make.leading.equalTo(safeAreaLayoutGuide).inset(20)
            make.trailing.equalTo(checkEmailButton.snp.leading).offset(-10)
            make.height.equalTo(44)
        }
        
        emailStackView.snp.makeConstraints { make in
            make.bottom.equalTo(emailTextField.snp.top).offset(-16)
            make.leading.equalTo(emailTextField)
        }
        
        explanationLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(emailTextField)
        }
        
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(explanationLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
    }
    
    override func configureView() {
        nextButton.backgroundColor = .gray
    }
}
