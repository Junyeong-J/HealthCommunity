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
        label.backgroundColor = .lightGray.withAlphaComponent(0.3)
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.textAlignment = .center
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private let topSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    private let mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let bottomSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = Font.bold14
        label.textColor = .myAppBlack
        label.numberOfLines = 0
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
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = Font.regular13
        label.textColor = .lightGray
        return label
    }()
    
    override func configureHierarchy() {
        contentView.addSubview(containerView)
        [opponentProfileImageView, nicknameLabel, topSeparatorView,
         mainImageView, bottomSeparatorView, contentLabel, commentButton,
         commentCountLabel, timeLabel].forEach { containerView.addSubview($0) }
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
        
        topSeparatorView.snp.makeConstraints { make in
            make.top.equalTo(opponentProfileImageView.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(1)
        }
        
        mainImageView.snp.makeConstraints { make in
            make.top.equalTo(topSeparatorView.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(200)
        }
        
        bottomSeparatorView.snp.makeConstraints { make in
            make.top.equalTo(mainImageView.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(1)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(bottomSeparatorView.snp.bottom).offset(10)
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
    
    func configure(post: Post) {
        nicknameLabel.text = post.creator.nick
        contentLabel.text = post.content2
        
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
            topSeparatorView.isHidden = false
            bottomSeparatorView.isHidden = false
        } else {
            mainImageView.image = nil
            mainImageView.snp.updateConstraints { make in
                make.height.equalTo(0)
            }
            mainImageView.isHidden = true
            topSeparatorView.isHidden = true
            bottomSeparatorView.isHidden = true
        }
        
        timeLabel.text = FormatterManager.shared.formatDate(from: post.createdAt)
        commentCountLabel.text = "\(post.comments.count)"
    }
}

