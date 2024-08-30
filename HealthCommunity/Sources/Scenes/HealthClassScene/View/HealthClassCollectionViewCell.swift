//
//  HealthClassCollectionViewCell.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/30/24.
//

import UIKit
import SnapKit
import Kingfisher

final class HealthClassCollectionViewCell: BaseCollectionViewCell {
    
    private let classImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .red
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        return label
    }()
    
    private let participantsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        return label
    }()
    
    private let hashtagLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .blue
        return label
    }()
    
    override func configureHierarchy() {
        [classImageView, titleLabel, priceLabel,
         timeLabel, participantsLabel,
         hashtagLabel].forEach { contentView.addSubview($0) }
    }
    
    override func configureLayout() {
        classImageView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalToSuperview()
            make.height.equalTo(150)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(classImageView.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(classImageView)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.trailing.equalTo(titleLabel)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(5)
            make.leading.trailing.equalTo(titleLabel)
        }
        
        hashtagLabel.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(5)
            make.leading.trailing.equalTo(titleLabel)
        }
        
        participantsLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(10)
            make.leading.equalTo(titleLabel)
        }
    }
    
    func configure(with post: Post) {
        KingfisherManager.shared.setHeaders()
        if let classImage = post.files.first {
            let url = URL(string: APIURL.baseURL + classImage)
            classImageView.kf.setImage(with: url)
        } else {
            classImageView.image = UIImage(named: "star")
        }
        
        titleLabel.text = post.title
        priceLabel.text = "\(post.price ?? 0)원"
        timeLabel.text = post.content
        participantsLabel.text = "\(post.content1 ?? "0")/\(post.content2 ?? "0") 참여중"
        hashtagLabel.text = post.hashTags.joined(separator: " ")
    }
}

