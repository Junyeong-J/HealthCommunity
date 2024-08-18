//
//  PasswordView.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/17/24.
//

import UIKit
import SnapKit

final class PasswordView: BaseView {
    
    private enum PasswordRequirements: String, CaseIterable {
        case containNumber = "숫자포함"
        case containSpecialCharacter = "특수문자 포함"
        case containLowercase = "소문자 포함"
        case length = "8~16자리"
        case noWhitespace = "공백문자 미포함"
        
        var description: String {
            return self.rawValue
        }
    }
    
    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호"
        label.font = Font.bold20
        return label
    }()
    
    private let passwordImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "lock.fill")?.withTintColor(.black, renderingMode: .alwaysOriginal))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var passwordStackView: UIStackView = {
        let stview = UIStackView(arrangedSubviews: [passwordImage, passwordLabel])
        stview.spacing = 5
        stview.axis = .horizontal
        stview.alignment = .fill
        return stview
    }()
    
    //MARK: - 이메일 입력부분
    let passwordInputTextField: LineTextField = {
        let tf = LineTextField(style: .passwordCheck)
        tf.textColor = .black
        tf.tintColor = .black
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        tf.isSecureTextEntry = true
        return tf
    }()
    
    //MARK: - 설명부분
    private func checkImage() -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }
    
    private func explainLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = Font.bold18
        label.textColor = .myAppGray
        return label
    }
    
    private func explainStackView(requirements: PasswordRequirements) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [checkImage(), explainLabel(text: requirements.description)])
        stackView.spacing = 8
        stackView.axis = .horizontal
        stackView.alignment = .fill
        return stackView
    }
    
    lazy var explainStackViews: [UIStackView] = {
        return PasswordRequirements.allCases.map { explainStackView(requirements: $0) }
    }()
    
    //MARK: - 버튼
    let passwordNextbt = BaseButton(title: .next)
    
    
    override func configureHierarchy() {
        [passwordInputTextField, passwordStackView, passwordNextbt].forEach { addSubview($0) }
        explainStackViews.forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        let topOffset = UIScreen.main.bounds.height * 0.3
        
        passwordInputTextField.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide.snp.top).offset(topOffset)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }
        
        passwordStackView.snp.makeConstraints { make in
            make.bottom.equalTo(passwordInputTextField.snp.top).offset(-16)
            make.leading.equalTo(passwordInputTextField)
        }
        
        for (index, stackView) in explainStackViews.enumerated() {
            stackView.snp.makeConstraints { make in
                if index == 0 {
                    make.top.equalTo(passwordInputTextField.snp.bottom).offset(16)
                } else {
                    make.top.equalTo(explainStackViews[index - 1].snp.bottom).offset(8)
                }
                make.leading.equalTo(passwordInputTextField)
            }
        }
        
        if let lastExplain = explainStackViews.last {
            passwordNextbt.snp.makeConstraints { make in
                make.top.equalTo(lastExplain.snp.bottom).offset(20)
                make.horizontalEdges.equalTo(passwordInputTextField)
                make.height.equalTo(50)
            }
        }
    }
    
}
