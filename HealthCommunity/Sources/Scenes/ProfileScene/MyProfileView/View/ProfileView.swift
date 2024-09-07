//
//  ProfileView.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/23/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ProfileView: BaseView {
    
    private let profileCardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 10
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 50
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 2.0
        imageView.layer.borderColor = UIColor.gray.cgColor
        imageView.image = UIImage(named: "default_profile")
        return imageView
    }()
    
    let nicknameLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    
    let introLabel: UILabel = {
        let label = UILabel()
        label.text = "자기소개를 입력하세요."
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = .gray
        return label
    }()
    
    let measurementsLabel: UILabel = {
        let label = UILabel()
        label.text = "벤치: 00kg 스쿼트: 00kg 데드: 00kg"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = .darkGray
        return label
    }()
    
    private let menuCardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 10
        return view
    }()
    
    let profileEditButton: UIButton = {
        let button = UIButton()
        button.setTitle(" 프로필 수정", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setImage(UIImage(systemName: "pencil"), for: .normal)
        button.contentHorizontalAlignment = .left
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.tintColor = .gray
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        return button
    }()
    
    let routineLikesButton: UIButton = {
        let button = UIButton()
        button.setTitle(" 루틴 좋아요 목록", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.contentHorizontalAlignment = .left
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.tintColor = .gray
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        return button
    }()
    
    let logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그아웃", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return button
    }()
    
    private let deleteAccountButton: UIButton = {
        let button = UIButton()
        button.setTitle("탈퇴하기", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return button
    }()
    
    override func configureHierarchy() {
        addSubview(profileCardView)
        profileCardView.addSubview(profileImageView)
        profileCardView.addSubview(nicknameLabel)
        profileCardView.addSubview(introLabel)
        profileCardView.addSubview(measurementsLabel)
        
        addSubview(menuCardView)
        menuCardView.addSubview(profileEditButton)
        menuCardView.addSubview(routineLikesButton)
        
        addSubview(logoutButton)
        addSubview(deleteAccountButton)
    }
    
    override func configureLayout() {
        profileCardView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(profileCardView).offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        introLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        measurementsLabel.snp.makeConstraints { make in
            make.top.equalTo(introLabel.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        menuCardView.snp.makeConstraints { make in
            make.top.equalTo(profileCardView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        profileEditButton.snp.makeConstraints { make in
            make.top.equalTo(menuCardView).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        routineLikesButton.snp.makeConstraints { make in
            make.top.equalTo(profileEditButton.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        logoutButton.snp.makeConstraints { make in
            make.top.equalTo(menuCardView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        deleteAccountButton.snp.makeConstraints { make in
            make.top.equalTo(logoutButton.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    func configureData(profile: [UserProfile]) {
        nicknameLabel.text = profile.first?.nick
        introLabel.text = profile.first?.phoneNum
        measurementsLabel.text = profile.first?.birthDay
        
        if let firstFile = profile.first?.profileImage {
            let url = URL(string: APIURL.baseURL + firstFile)
            profileImageView.kf.setImage(with: url)
        } else {
            profileImageView.image = UIImage(named: "star")
        }
    }
}

extension ProfileView: NaviProtocol {
    var navigationTitle: String {
        return NavigationTitle.profile.title
    }
}
