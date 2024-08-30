//
//  MainFeedbackTableViewCell.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/23/24.
//

import UIKit
import SnapKit
import Kingfisher
import RxSwift
import RxCocoa

final class MainFeedbackTableViewCell: BaseTableViewCell {
    
    private var disposeBag = DisposeBag()
    
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
        contentView.addSubview(containerView)
        [opponentProfileImageView, nicknameLabel,
         mainImageView, contentLabel, timeLabel].forEach { containerView.addSubview($0) }
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
        
        mainImageView.snp.makeConstraints { make in
            make.top.equalTo(opponentProfileImageView.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview()
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
    
    func configure(post: Post) {
        nicknameLabel.text = post.creator.nick
        contentLabel.text = post.content
        
        if let createImage = post.creator.profileImage {
            let url = URL(string: APIURL.baseURL + createImage)
            opponentProfileImageView.kf.setImage(with: url)
        } else {
            opponentProfileImageView.image = UIImage(named: "star")
        }
        
        if let firstFile = post.files.first, !firstFile.isEmpty {
            let url = URL(string: APIURL.baseURL + firstFile)
            mainImageView.kf.setImage(with: url)
            mainImageView.snp.updateConstraints { make in
                make.height.equalTo(200)
            }
            mainImageView.isHidden = false
        } else {
            mainImageView.image = nil
            mainImageView.snp.updateConstraints { make in
                make.height.equalTo(0)
            }
            mainImageView.isHidden = true
        }
        
        timeLabel.text = FormatterManager.shared.formatDate(from: post.createdAt)
    }
}

