//
//  NicknameView.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/17/24.
//

import UIKit
import SnapKit

final class NicknameView: BaseView {
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임"
        label.font = Font.bold20
        return label
    }()
    
    private let nicknameImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "person.crop.square.fill")?.withTintColor(.black, renderingMode: .alwaysOriginal))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var nicknameStackView: UIStackView = {
        let stview = UIStackView(arrangedSubviews: [nicknameImage, nicknameLabel])
        stview.spacing = 5
        stview.axis = .horizontal
        stview.alignment = .fill
        return stview
    }()
    
    //MARK: - 닉네임 입력부분
    lazy var nicknameInputTextField: LineTextField = {
        let tf = LineTextField(style: .nickname)
        tf.textColor = .black
        tf.tintColor = .black
        return tf
    }()
    
    //MARK: - 설명부분
    private let nicknameExplainLabel: UILabel = {
        let label = UILabel()
        label.text = "2~10자리, 공백 안됨!"
        label.font = Font.bold15
        label.textColor = .black
        return label
    }()
    
    //MARK: - 버튼
    let joinCompletebt = BaseButton(title: .join)
    
    
    override func configureHierarchy() {
        [nicknameStackView, nicknameInputTextField,
         nicknameExplainLabel, joinCompletebt].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        let topOffset = UIScreen.main.bounds.height * 0.3

        nicknameInputTextField.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide.snp.top).offset(topOffset)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }
        
        nicknameStackView.snp.makeConstraints { make in
            make.bottom.equalTo(nicknameInputTextField.snp.top).offset(-16)
            make.leading.equalTo(nicknameInputTextField)
        }
        
        nicknameExplainLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameInputTextField.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(nicknameInputTextField)
        }
        
        joinCompletebt.snp.makeConstraints { make in
            make.top.equalTo(nicknameExplainLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
    }
    
}
