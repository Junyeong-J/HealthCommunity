//
//  FitnessAreaCollectionViewCell.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/27/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class FitnessAreaCollectionViewCell: BaseCollectionViewCell {
    
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Font.regular14
        label.textColor = .myAppBlack
        label.textAlignment = .center
        return label
    }()
    
    override func configureHierarchy() {
        contentView.addSubview(titleLabel)
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.center.equalTo(contentView)
        }
    }
    
    override func configureView() {
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.myAppGray.cgColor
        contentView.layer.cornerRadius = 18
    }
    
    func configure(title: String, isSelected: Bool) {
        titleLabel.text = title
        if isSelected {
            contentView.backgroundColor = .myAppMain
            titleLabel.textColor = .myAppWhite
        } else {
            contentView.backgroundColor = .myAppWhite
            titleLabel.textColor = .myAppBlack
        }
    }
}
