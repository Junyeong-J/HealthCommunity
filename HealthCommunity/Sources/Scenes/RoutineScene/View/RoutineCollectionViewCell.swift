//
//  RoutineCollectionViewCell.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/21/24.
//

import UIKit
import SnapKit

final class RoutineCollectionViewCell: BaseCollectionViewCell {
    
    let routineButton = RoutineAreaButton()
    
    override func configureHierarchy() {
        contentView.addSubview(routineButton)
    }
    
    override func configureLayout() {
        routineButton.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(5)
        }
    }
    
    func configure(with title: String) {
        routineButton.setTitle(title, for: .normal)
    }
}
