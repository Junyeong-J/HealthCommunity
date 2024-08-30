//
//  HealthClassDetailView.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/30/24.
//

import UIKit
import SnapKit

final class HealthClassDetailView: BaseView {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let classImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private let infoContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 4
        return view
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.text = "장소:"
        label.numberOfLines = 0
        return label
    }()
    
    private let locationInfoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.numberOfLines = 0
        return label
    }()
    
    private let targetLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.text = "대상:"
        label.numberOfLines = 0
        return label
    }()
    
    private let targetInfoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.numberOfLines = 0
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.text = "시간:"
        label.numberOfLines = 0
        return label
    }()
    
    private let timeInfoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.numberOfLines = 0
        return label
    }()
    
    private let participantsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.text = "참여 인원:"
        label.numberOfLines = 0
        return label
    }()
    
    private let participantsInfoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.numberOfLines = 0
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.text = "가격:"
        label.numberOfLines = 0
        return label
    }()
    
    private let priceInfoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.numberOfLines = 0
        return label
    }()
    
    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("결제하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .myAppMain
        button.layer.cornerRadius = 10
        return button
    }()
    
    override func configureHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(classImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(infoContainerView)
        contentView.addSubview(actionButton)
        
        [locationLabel, locationInfoLabel, targetLabel, targetInfoLabel,
         timeLabel, timeInfoLabel, participantsLabel, participantsInfoLabel,
         priceLabel, priceInfoLabel].forEach {
            infoContainerView.addSubview($0)
        }
    }
    
    override func configureLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.width.equalTo(scrollView.snp.width)
            make.verticalEdges.equalTo(scrollView)
        }
        
        classImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(10)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(300)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(classImageView.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(classImageView).inset(10)
        }
        
        infoContainerView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(classImageView).inset(10)
        }
        
        locationLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(10)
        }
        
        locationInfoLabel.snp.makeConstraints { make in
            make.leading.equalTo(locationLabel.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(10)
            make.top.equalTo(locationLabel)
        }
        
        targetLabel.snp.makeConstraints { make in
            make.top.equalTo(locationLabel.snp.bottom).offset(10)
            make.leading.equalTo(locationLabel)
        }
        
        targetInfoLabel.snp.makeConstraints { make in
            make.leading.equalTo(targetLabel.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(10)
            make.top.equalTo(targetLabel)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(targetLabel.snp.bottom).offset(10)
            make.leading.equalTo(locationLabel)
        }
        
        timeInfoLabel.snp.makeConstraints { make in
            make.leading.equalTo(timeLabel.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(10)
            make.top.equalTo(timeLabel)
        }
        
        participantsLabel.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(10)
            make.leading.equalTo(locationLabel)
        }
        
        participantsInfoLabel.snp.makeConstraints { make in
            make.leading.equalTo(participantsLabel.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(10)
            make.top.equalTo(participantsLabel)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(participantsLabel.snp.bottom).offset(10)
            make.leading.equalTo(locationLabel)
            make.bottom.equalToSuperview().inset(10)
        }
        
        priceInfoLabel.snp.makeConstraints { make in
            make.leading.equalTo(priceLabel.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(10)
            make.centerY.equalTo(priceLabel)
        }
        
        actionButton.snp.makeConstraints { make in
            make.top.equalTo(infoContainerView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(classImageView).inset(10)
            make.height.equalTo(50)
            make.bottom.equalTo(contentView).offset(-20)
        }
    }
    
    override func configureView() {
        classImageView.backgroundColor = .gray
        titleLabel.text = "classData.title"
        locationInfoLabel.text = "classData.location"
        targetInfoLabel.text = "classData.target"
        timeInfoLabel.text = "classData.time"
        participantsInfoLabel.text = "classData.currentParticipants)/(classData.maxParticipants)"
        priceInfoLabel.text = "classData.price원"
    }
}


#if DEBUG

import SwiftUI

struct ViewControllerPresentable: UIViewControllerRepresentable{
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        HealthClassDetailViewController()
    }
}

struct ViewControllerPrepresentable_PreviewProvider : PreviewProvider{
    static var previews: some View{
        ViewControllerPresentable()
    }
}

#endif
