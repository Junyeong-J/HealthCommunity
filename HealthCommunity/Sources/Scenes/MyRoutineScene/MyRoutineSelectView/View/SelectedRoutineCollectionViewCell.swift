//
//  SelectedRoutineCollectionViewCell.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/28/24.
//

import UIKit
import SnapKit
import RxSwift

final class SelectedRoutineCollectionViewCell: BaseCollectionViewCell {
    
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Font.regular14
        label.textColor = .myAppBlack
        return label
    }()
    
    let deleteButton = DeleteButton()
    
    override func configureHierarchy() {
        [titleLabel, deleteButton].forEach { contentView.addSubview($0) }
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
        }
        
        deleteButton.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(8)
            make.centerY.trailing.equalToSuperview()
            make.size.equalTo(20)
        }
    }
    
    func configure(title: String) {
        titleLabel.text = title
    }
}
