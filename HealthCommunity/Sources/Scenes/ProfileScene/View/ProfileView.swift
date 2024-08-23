//
//  ProfileView.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/23/24.
//

import UIKit
import SnapKit

final class ProfileView: BaseView {
    
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
    
    let bioLabel: UILabel = {
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
    
    let tableView: UITableView = {
        let view = UITableView()
        view.register(ProfileListTableViewCell.self, forCellReuseIdentifier: ProfileListTableViewCell.identifier)
        view.rowHeight = 50
        view.separatorStyle = .none
        return view
    }()
    
    override func configureHierarchy() {
        addSubview(profileImageView)
        addSubview(nicknameLabel)
        addSubview(bioLabel)
        addSubview(measurementsLabel)
        addSubview(tableView)
    }
    
    override func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        bioLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        measurementsLabel.snp.makeConstraints { make in
            make.top.equalTo(bioLabel.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(measurementsLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide).inset(20)
        }
    }
}
