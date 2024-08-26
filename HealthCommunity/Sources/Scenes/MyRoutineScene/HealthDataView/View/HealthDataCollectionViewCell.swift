//
//  HealthDataCollectionViewCell.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/26/24.
//

import UIKit
import SnapKit

final class HealthDataCollectionViewCell: BaseCollectionViewCell {
    
    private let titleLabel = UILabel()
    private let valueLabel = UILabel()
    
    override func configureView() {
        contentView.backgroundColor = .systemGray6
        contentView.layer.cornerRadius = 10
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        valueLabel.font = UIFont.systemFont(ofSize: 14)
        valueLabel.textColor = .darkGray
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 10
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }
    
    func configure(data: HealthDataItem) {
        switch data.type {
        case .steps:
            titleLabel.text = "걸음 수"
        case .calories:
            titleLabel.text = "칼로리 소모"
        case .strengthTraining:
            titleLabel.text = "근력 훈련"
        case .standingHours:
            titleLabel.text = "서 있는 시간"
        }
        valueLabel.text = data.value
    }
    
}
