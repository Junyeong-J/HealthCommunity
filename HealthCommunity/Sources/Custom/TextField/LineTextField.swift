//
//  LineTextField.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/16/24.
//

import UIKit
import SnapKit

//MARK: - 밑줄 그어지는 애니메이션
class NicknameTextField: UITextField {
    
    private let myUnderlLine = UIProgressView(progressViewStyle: .bar)

    init(style: TextFieldPlaceholder) {
        super.init(frame: .zero)
        placeholder = style.rawValue
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        
        myUnderlLine.trackTintColor = .myAppGray //처음 색상
        myUnderlLine.progressTintColor = .myAppMain //변경 색상
        
        addSubview(myUnderlLine)
        
        myUnderlLine.snp.makeConstraints { make in
            make.height.equalTo(2)
            make.left.right.equalToSuperview()
            make.top.equalTo(snp.bottom).offset(3)
        }
        
        delegate = self
    }
}

extension NicknameTextField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.20) {
            self.myUnderlLine.setProgress(1.0, animated: true)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.20) {
            self.myUnderlLine.setProgress(0.0, animated: true)
        }
    }
}
