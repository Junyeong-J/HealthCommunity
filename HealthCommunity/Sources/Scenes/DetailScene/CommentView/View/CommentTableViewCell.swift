//
//  WodCommentTableViewCell.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/25/24.
//

import UIKit
import SnapKit
import Kingfisher

final class CommentTableViewCell: BaseTableViewCell {
    
    private let profileImageView = OpponentProfileImage()
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()
    
    private let commentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.numberOfLines = 0
        return label
    }()
    
    override func configureHierarchy() {
        [profileImageView, nicknameLabel, dateLabel, commentLabel].forEach { contentView.addSubview($0) }
    }
    
    override func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(16)
            make.size.equalTo(40)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView)
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(nicknameLabel)
            make.trailing.equalToSuperview().inset(16)
        }
        
        commentLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(8)
            make.leading.equalTo(nicknameLabel)
            make.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
        }
    }

    
    
    func configure(with comment: Comments) {
        if let profileImageUrl = URL(string: APIURL.baseURL + (comment.creator.profileImage ?? "")) {
            profileImageView.kf.setImage(with: profileImageUrl)
        } else {
            profileImageView.image = UIImage(systemName: "person.fill")
        }
        
        nicknameLabel.text = comment.creator.nick
//        dateLabel.text = comment.createdDate
        commentLabel.text = comment.content
    }
}
