//
//  MainWodTableViewCell.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/22/24.
//

import UIKit
import SnapKit
import Kingfisher
import RxSwift
import RxCocoa

final class MainWodTableViewCell: BaseTableViewCell {
    
    private let containerView: ShadowRoundedView = {
        let view = ShadowRoundedView()
        view.backgroundColor = .white
        return view
    }()
    
    private let opponentProfileImageView = OpponentProfileImage()
    
    private var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
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
    
    private let likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        return button
    }()

    private let likeCountLabel: UILabel = {
        let label = UILabel()
        label.font = Font.bold14
        label.textColor = .darkGray
        return label
    }()

    private let commentButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "message.fill"), for: .normal)
        return button
    }()

    private let commentCountLabel: UILabel = {
        let label = UILabel()
        label.font = Font.bold14
        label.textColor = .darkGray
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
    
    override func configureHierarchy() {
        contentView.addSubview(containerView)
        [opponentProfileImageView, nicknameLabel,
         mainImageView, likeButton, likeCountLabel,
         commentButton, commentCountLabel, contentLabel, timeLabel].forEach { containerView.addSubview($0) }
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
        
        likeButton.snp.makeConstraints { make in
            make.top.equalTo(mainImageView.snp.bottom).offset(10)
            make.leading.equalToSuperview().inset(10)
            make.width.height.equalTo(24)
        }
        
        likeCountLabel.snp.makeConstraints { make in
            make.leading.equalTo(likeButton.snp.trailing).offset(10)
            make.centerY.equalTo(likeButton)
        }
        
        commentButton.snp.makeConstraints { make in
            make.leading.equalTo(likeCountLabel.snp.trailing).offset(20)
            make.centerY.equalTo(likeButton)
            make.width.height.equalTo(24)
        }
        
        commentCountLabel.snp.makeConstraints { make in
            make.leading.equalTo(commentButton.snp.trailing).offset(10)
            make.centerY.equalTo(likeButton)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(likeButton.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(10)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(10)
            make.leading.bottom.equalToSuperview().inset(10)
        }
    }
    
    func configure(post: Post) {
        KingfisherManager.shared.setHeaders()
        nicknameLabel.text = post.creator.nick
        contentLabel.text = post.content
        
        if let createImage = post.creator.profileImage {
            let url = URL(string: APIURL.baseURL + createImage)
            opponentProfileImageView.kf.setImage(with: url)
        } else {
            opponentProfileImageView.image = UIImage(named: "star")
        }
        
        if let firstFile = post.files.first {
            let url = URL(string: APIURL.baseURL + firstFile)
            mainImageView.kf.setImage(with: url)
        } else {
            mainImageView.image = UIImage(named: "star")
        }
        
        timeLabel.text = FormatterManager.shared.formatDate(from: post.createdAt)
        
//        likeButton.isSelected = post.likes.contains(currentUserId)
        likeCountLabel.text = "\(post.likes.count)"
        commentCountLabel.text = "\(post.comments.count)"
        
        // 좋아요 버튼 액션
        likeButton.rx.tap
            .bind { [weak self] in
                self?.likeButton.isSelected.toggle()
                // 좋아요 상태를 서버에 전송하는 로직 추가
            }
            .disposed(by: disposeBag)
    }
    
}

extension KingfisherManager {
    
    func setHeaders() {
        let modifier = AnyModifier { request in
            var req = request
            req.addValue(UserDefaultsManager.shared.token, forHTTPHeaderField: Header.authorization.rawValue)
            req.addValue(APIKey.key, forHTTPHeaderField: Header.sesacKey.rawValue)
            return req
        }
        
        KingfisherManager.shared.defaultOptions = [
            .requestModifier(modifier)
        ]
    }
    
}

