//
//  MainTableViewCell.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/22/24.
//

import UIKit
import SnapKit

final class MainTableViewCell: BaseTableViewCell {
    
    private let opponentProfileImageView = OpponentProfileImage()
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = Font.bold16
        label.textColor = .myAppBlack
        return label
    }()
    
    private let mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = Font.bold14
        label.textColor = .myAppBlack
        label.numberOfLines = 0
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = Font.regular13
        label.textColor = .lightGray
        return label
    }()
    
    override func configureHierarchy() {
        [opponentProfileImageView, nicknameLabel,
         mainImageView, contentLabel, timeLabel].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        opponentProfileImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(10)
            make.width.height.equalTo(40)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.leading.equalTo(opponentProfileImageView.snp.trailing).offset(10)
            make.centerY.equalTo(opponentProfileImageView)
        }
        
        mainImageView.snp.makeConstraints { make in
            make.top.equalTo(opponentProfileImageView.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(10)
            make.height.equalTo(200)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(mainImageView.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(10)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(10)
            make.leading.bottom.equalToSuperview().inset(10)
        }
    }
    
    override func configureView() {
        timeLabel.text = "7시간 전"
        contentLabel.text = "오운완"
        mainImageView.backgroundColor = .gray
        nicknameLabel.text = "하루"
    }
    
}

