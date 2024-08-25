//
//  WodDetailView.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/25/24.
//

import UIKit
import SnapKit
import Kingfisher

final class WodDetailView: BaseView {
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    private let profileImageView = OpponentProfileImage()
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = Font.bold16
        label.textColor = .myAppBlack
        return label
    }()
    
    private let mainImageView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private let postContentLabel: UILabel = {
        let label = UILabel()
        label.font = Font.regular14
        label.textColor = .darkGray
        label.numberOfLines = 0
        return label
    }()
    
    private let routineToggleView = ToggleDetailView(title: "루틴", buttonText: "내 루틴에 저장")
    private let nutrientsToggleView = ToggleDetailView(title: "영양소", buttonText: nil)
    private let exerciseTimeToggleView = ToggleDetailView(title: "운동시간", buttonText: nil)
    private let calorieToggleView = ToggleDetailView(title: "칼로리", buttonText: nil)
    
    let showCommentsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("댓글 보기", for: .normal)
        return button
    }()
    
    override func configureHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [profileImageView, nicknameLabel, mainImageView,
         postContentLabel, routineToggleView, nutrientsToggleView,
         exerciseTimeToggleView, calorieToggleView, showCommentsButton].forEach { contentView.addSubview($0) }
    }
    
    override func configureLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.width.equalTo(scrollView.snp.width)
            make.verticalEdges.equalTo(scrollView)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.leading.equalTo(contentView).inset(16)
            make.size.equalTo(40)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageView)
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
        }
        
        mainImageView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(contentView).inset(16)
            make.height.equalTo(300)
        }
        
        postContentLabel.snp.makeConstraints { make in
            make.top.equalTo(mainImageView.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(contentView).inset(16)
        }
        
        routineToggleView.snp.makeConstraints { make in
            make.top.equalTo(postContentLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(contentView).inset(16)
        }
        
        nutrientsToggleView.snp.makeConstraints { make in
            make.top.equalTo(routineToggleView.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(contentView).inset(16)
        }
        
        exerciseTimeToggleView.snp.makeConstraints { make in
            make.top.equalTo(nutrientsToggleView.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(contentView).inset(16)
        }
        
        calorieToggleView.snp.makeConstraints { make in
            make.top.equalTo(exerciseTimeToggleView.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(contentView).inset(16)
        }
        
        showCommentsButton.snp.makeConstraints { make in
            make.top.equalTo(calorieToggleView.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(contentView).inset(16)
            make.bottom.equalTo(contentView).inset(16)
            make.height.equalTo(50)
        }
    }
    
    func configureData(data: Post) {
        
        if let profileImageUrl = URL(string: APIURL.baseURL + (data.creator.profileImage ?? "")) {
            profileImageView.kf.setImage(with: profileImageUrl)
        } else {
            profileImageView.image = UIImage(systemName: "star.fill")
        }
        
        nicknameLabel.text = data.creator.nick
        postContentLabel.text = data.content
        
        mainImageView.subviews.forEach { $0.removeFromSuperview() }
        
        let imageUrls = data.files.compactMap { URL(string: APIURL.baseURL + $0) }
        var previousImageView: UIImageView?
        for (index, imageUrl) in imageUrls.enumerated() {
            let imageView = UIImageView()
            imageView.contentMode = .scaleToFill
            imageView.kf.setImage(with: imageUrl)
            mainImageView.addSubview(imageView)
            
            imageView.snp.makeConstraints { make in
                make.top.bottom.equalTo(mainImageView)
                make.width.equalTo(mainImageView)
                make.height.equalTo(300)
                
                if let previous = previousImageView {
                    make.leading.equalTo(previous.snp.trailing)
                } else {
                    make.leading.equalTo(mainImageView)
                }
                
                if index == imageUrls.count - 1 {
                    make.trailing.equalTo(mainImageView)
                }
            }
            
            previousImageView = imageView
        }
        
        routineToggleView.setContentText(data.content2)
        nutrientsToggleView.setContentText(data.content3)
        exerciseTimeToggleView.setContentText(data.content4)
        calorieToggleView.setContentText(data.content2)
    }
}
