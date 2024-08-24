//
//  ProfileListTableViewCell.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/23/24.
//

import UIKit
import SnapKit

final class ProfileListTableViewCell: BaseTableViewCell {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    override func configureHierarchy() {
        addSubview(titleLabel)
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(15)
        }
        
    }
    
    func configure(with title: String) {
        titleLabel.text = title
    }
    
}
