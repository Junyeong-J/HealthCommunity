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
    
    func configure(post: Post) {
        KingfisherManager.shared.setHeaders()
        nicknameLabel.text = post.creator.nick
        contentLabel.text = post.content
        
        if let firstFile = post.files.first {
            let url = URL(string: APIURL.baseURL + firstFile)
            mainImageView.kf.setImage(with: url)
        } else {
            mainImageView.image = UIImage(named: "placeholder_image")
        }
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
