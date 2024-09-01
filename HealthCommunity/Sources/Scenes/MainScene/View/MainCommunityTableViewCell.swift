//
//  MainCommunityTableViewCell.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/23/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class MainCommunityTableViewCell: BaseTableViewCell {
    
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    private let containerView: ShadowRoundedView = {
        let view = ShadowRoundedView()
        view.backgroundColor = .white
        return view
    }()
    
    private let opponentProfileImageView = OpponentProfileImage()
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = Font.bold16
        label.textColor = .myAppBlack
        return label
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
    
    let commentButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "message")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .myAppMain
        return button
    }()
    
    private let commentCountLabel: UILabel = {
        let label = UILabel()
        label.font = Font.bold14
        label.textColor = .darkGray
        return label
    }()
    
    override func configureHierarchy() {
        contentView.addSubview(containerView)
        [opponentProfileImageView, nicknameLabel, contentLabel,
         timeLabel, commentButton, commentCountLabel].forEach { containerView.addSubview($0) }
    }
    
    override func configureLayout() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        opponentProfileImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(10)
            make.width.height.equalTo(40)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.leading.equalTo(opponentProfileImageView.snp.trailing).offset(10)
            make.centerY.equalTo(opponentProfileImageView)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(opponentProfileImageView.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(10)
        }
        
        commentButton.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
            make.size.equalTo(24)
        }
        
        commentCountLabel.snp.makeConstraints { make in
            make.leading.equalTo(commentButton.snp.trailing).offset(5)
            make.centerY.equalTo(commentButton)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(commentButton.snp.bottom).offset(10)
            make.leading.bottom.equalToSuperview().inset(10)
        }
    }
    
    override func configureView() {
        timeLabel.text = "7시간 전"
        contentLabel.text = "오운완"
        nicknameLabel.text = "하루"
    }
    
    func configure(post: Post) {
        
        if let createImage = post.creator.profileImage {
            let url = URL(string: APIURL.baseURL + createImage)
            opponentProfileImageView.kf.setImage(with: url)
        } else {
            opponentProfileImageView.image = UIImage(named: "star")
        }
        
        nicknameLabel.text = post.creator.nick
        contentLabel.text = post.content
        timeLabel.text = FormatterManager.shared.formatDate(from: post.createdAt)
        commentCountLabel.text = "\(post.comments.count)"
    }
}

