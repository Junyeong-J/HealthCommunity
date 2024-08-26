//
//  MyRoutineMenuTableViewCell.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/26/24.
//

import UIKit
import SnapKit

final class MyRoutineMenuTableViewCell: BaseTableViewCell {
    
    private let menuTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    private let chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .gray
        return imageView
    }()
    
    override func configureHierarchy() {
        contentView.addSubview(menuTitle)
        contentView.addSubview(chevronImageView)
    }
    
    override func configureLayout() {
        menuTitle.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        chevronImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
    }
    
    func configure(data: String) {
        menuTitle.text = data
    }
    
}

