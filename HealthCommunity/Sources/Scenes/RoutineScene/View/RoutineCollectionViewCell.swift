//
//  RoutineCollectionViewCell.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/21/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class RoutineCollectionViewCell: BaseCollectionViewCell {
    
    private var disposeBag = DisposeBag()
    
    let routineButton = RoutineAreaButton()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override func configureHierarchy() {
        contentView.addSubview(routineButton)
    }
    
    override func configureLayout() {
        routineButton.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(5)
        }
    }
    
    func configure(title: String, isSelected: Bool) {
        routineButton.setTitle(title, for: .normal)
        updateButtonStyle(isSelected: isSelected)
    }
    
    private func updateButtonStyle(isSelected: Bool) {
        if isSelected {
            routineButton.backgroundColor = .black
            routineButton.setTitleColor(.white, for: .normal)
        } else {
            routineButton.backgroundColor = .white
            routineButton.setTitleColor(.black, for: .normal)
        }
    }
}

