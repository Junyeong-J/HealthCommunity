//
//  LikeRoutineHeaderView.swift
//  HealthCommunity
//
//  Created by 전준영 on 9/1/24.
//

import UIKit
import SnapKit
import Kingfisher

final class LikeRoutineHeaderView: UITableViewHeaderFooterView {
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 40
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 2.0
        imageView.layer.borderColor = UIColor.gray.cgColor
        return imageView
    }()
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy() {
        addSubview(profileImageView)
        addSubview(nicknameLabel)
    }
    
    private func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(80)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    func configure(with creator: Creator) {
        nicknameLabel.text = creator.nick
        if let profileImageUrl = URL(string: APIURL.baseURL + (creator.profileImage ?? "")) {
            profileImageView.kf.setImage(with: profileImageUrl)
        } else {
            profileImageView.image = UIImage(named: "default_profile")
        }
    }
}


