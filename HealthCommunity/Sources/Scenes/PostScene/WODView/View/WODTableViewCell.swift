//
//  WODTableViewCell.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/20/24.
//

import UIKit
import SnapKit

final class WODTableViewCell: BaseTableViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Font.bold16
        label.textColor = .myAppBlack
        label.backgroundColor = .clear
        label.textAlignment = .left
        return label
    }()
    let triangleImageView = TriangleImage()
    
    override func configureHierarchy() {
        [titleLabel, triangleImageView].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        triangleImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(18)
            make.trailing.equalToSuperview().inset(16)
        }
    }
    
    
    func configureData(title: String) {
        titleLabel.text = title
    }
}
