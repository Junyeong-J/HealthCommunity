//
//  EditProfileView.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/24/24.
//

import UIKit
import SnapKit

final class EditProfileView: BaseView {
    
    private let profileImageView = MyProfileImageView()
    let editProfileButton = ProfileChangeButton(title: .changeProfile)
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임"
        label.font = Font.regular14
        label.textColor = .darkGray
        return label
    }()
    
    let nicknameTextField = BoxTypeProfileTextField(style: .editNick)
    
    private let introduceLabel: UILabel = {
        let label = UILabel()
        label.text = "소개"
        label.font = Font.regular14
        label.textColor = .darkGray
        return label
    }()
    
    let introduceTextField = BoxTypeProfileTextField(style: .introduce)
    
    private let benchLabel: UILabel = {
        let label = UILabel()
        label.text = "벤치"
        label.font = Font.regular14
        label.textColor = .darkGray
        return label
    }()
    
    let benchTextField: BoxTypeProfileTextField = {
        let textField = BoxTypeProfileTextField(style: .bench)
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private let benchKgLabel: UILabel = {
        let label = UILabel()
        label.text = "kg"
        label.font = Font.regular14
        label.textColor = .darkGray
        return label
    }()
    
    private let squatLabel: UILabel = {
        let label = UILabel()
        label.text = "스쿼트"
        label.font = Font.regular14
        label.textColor = .darkGray
        return label
    }()
    
    let squatTextField: BoxTypeProfileTextField = {
        let textField = BoxTypeProfileTextField(style: .squat)
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private let squatKgLabel: UILabel = {
        let label = UILabel()
        label.text = "kg"
        label.font = Font.regular14
        label.textColor = .darkGray
        return label
    }()
    
    private let deadliftLabel: UILabel = {
        let label = UILabel()
        label.text = "데드"
        label.font = Font.regular14
        label.textColor = .darkGray
        return label
    }()
    
    let deadliftTextField: BoxTypeProfileTextField = {
        let textField = BoxTypeProfileTextField(style: .deadlift)
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private let deadliftKgLabel: UILabel = {
        let label = UILabel()
        label.text = "kg"
        label.font = Font.regular14
        label.textColor = .darkGray
        return label
    }()
    
    let saveButton = ProfileChangeButton(title: .editProfile)
    
    override func configureHierarchy() {
        
        [profileImageView, editProfileButton, nicknameLabel,
         nicknameTextField, introduceLabel, introduceTextField,
         benchLabel, benchTextField, benchKgLabel,
         squatLabel, squatTextField, squatKgLabel,
         deadliftLabel, deadliftTextField, deadliftKgLabel,
         saveButton].forEach { addSubview($0) }
        
    }
    
    override func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(30)
            make.centerX.equalToSuperview()
            make.size.equalTo(150)
        }
        
        editProfileButton.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(40)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(editProfileButton.snp.bottom).offset(30)
            make.leading.equalToSuperview().inset(20)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        introduceLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(20)
        }
        
        introduceTextField.snp.makeConstraints { make in
            make.top.equalTo(introduceLabel.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        benchLabel.snp.makeConstraints { make in
            make.top.equalTo(introduceTextField.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(20)
        }
        
        benchKgLabel.snp.makeConstraints { make in
            make.centerY.equalTo(benchLabel)
            make.trailing.equalTo(safeAreaLayoutGuide.snp.centerX)
        }
        
        benchTextField.snp.makeConstraints { make in
            make.centerY.equalTo(benchLabel)
            make.trailing.equalTo(benchKgLabel.snp.leading).offset(-10)
            make.width.equalTo(60)
            make.height.equalTo(40)
        }
        
        squatLabel.snp.makeConstraints { make in
            make.top.equalTo(benchLabel.snp.bottom).offset(25)
            make.leading.equalToSuperview().inset(20)
        }
        
        squatKgLabel.snp.makeConstraints { make in
            make.centerY.equalTo(squatLabel)
            make.trailing.equalTo(safeAreaLayoutGuide.snp.centerX)
        }
        
        squatTextField.snp.makeConstraints { make in
            make.centerY.equalTo(squatLabel)
            make.trailing.equalTo(squatKgLabel.snp.leading).offset(-10)
            make.width.equalTo(60)
            make.height.equalTo(40)
        }
        
        deadliftLabel.snp.makeConstraints { make in
            make.top.equalTo(squatLabel.snp.bottom).offset(25)
            make.leading.equalToSuperview().inset(20)
        }
        
        deadliftKgLabel.snp.makeConstraints { make in
            make.centerY.equalTo(deadliftLabel)
            make.trailing.equalTo(safeAreaLayoutGuide.snp.centerX)
        }
        
        deadliftTextField.snp.makeConstraints { make in
            make.centerY.equalTo(deadliftLabel)
            make.trailing.equalTo(deadliftKgLabel.snp.leading).offset(-10)
            make.width.equalTo(60)
            make.height.equalTo(40)
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(deadliftLabel.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
    }
    
    func handleImage(image: UIImage) {
        self.profileImageView.image = image
    }
    
    func originalData(profile: UserProfile) {
        if let firstFile = profile.profileImage {
            let url = URL(string: APIURL.baseURL + firstFile)
            profileImageView.kf.setImage(with: url)
        } else {
            profileImageView.image = UIImage(named: "star")
        }
        
        nicknameTextField.text = profile.nick
        introduceTextField.text = profile.phoneNum
        
        let infoString = profile.birthDay ?? ""
        
        let components = infoString.components(separatedBy: " ")
        
        var benchValue: String?
        var squatValue: String?
        var deadliftValue: String?
        
        if components.count > 1 {
            benchValue = components[1]
                .replacingOccurrences(of: "벤치:", with: "")
                .replacingOccurrences(of: "kg", with: "")
                .trimmingCharacters(in: .whitespaces)
        }
        
        if components.count > 3 {
            squatValue = components[3]
                .replacingOccurrences(of: "스쿼트:", with: "")
                .replacingOccurrences(of: "kg", with: "")
                .trimmingCharacters(in: .whitespaces)
        }
        
        if components.count > 5 {
            deadliftValue = components[5]
                .replacingOccurrences(of: "데드:", with: "")
                .replacingOccurrences(of: "kg", with: "")
                .trimmingCharacters(in: .whitespaces)
        }
        
        benchTextField.text = benchValue
        squatTextField.text = squatValue
        deadliftTextField.text = deadliftValue
    }
    
}
