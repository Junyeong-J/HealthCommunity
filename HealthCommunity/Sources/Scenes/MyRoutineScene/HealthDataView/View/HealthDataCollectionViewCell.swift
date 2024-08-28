//
//  HealthDataCollectionViewCell.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/26/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class HealthDataCollectionViewCell: BaseCollectionViewCell {
    
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Font.bold16
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = Font.bold20
        label.textColor = .darkGray
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func configureHierarchy() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(iconImageView)
        contentView.addSubview(valueLabel)
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.leading.equalToSuperview().inset(10)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.leading.equalTo(titleLabel.snp.trailing).offset(10)
            make.trailing.lessThanOrEqualToSuperview().inset(10)
            make.width.height.equalTo(20)
        }
        
        valueLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
    }
    
    override func configureView() {
        contentView.backgroundColor = .systemGray6
        contentView.layer.cornerRadius = 10
    }
    
    func configure(data: HealthDataItem) {
        switch data.type {
        case .steps:
            titleLabel.text = "걸음 수"
            iconImageView.image = UIImage(systemName: "figure.walk")
        case .calories:
            titleLabel.text = "칼로리 소모"
            iconImageView.image = UIImage(systemName: "flame")
        case .strengthTraining:
            titleLabel.text = "이동거리"
            iconImageView.image = UIImage(systemName: "location.north.line")
        case .standingHours:
            titleLabel.text = "서 있는 시간"
            iconImageView.image = UIImage(systemName: "clock")
        }
        valueLabel.text = data.value
    }
}
