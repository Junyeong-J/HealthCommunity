//
//  MyRoutineSelectTableViewCell.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/27/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class MyRoutineSelectTableViewCell: BaseTableViewCell {
    
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    let checkBoxButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square"), for: .normal)
        button.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
        button.tintColor = .myAppMain
        return button
    }()
    
    private let routineImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.tintColor = .black
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Font.regular16
        label.textColor = .myAppBlack
        return label
    }()
    
    override func configureHierarchy() {
        [checkBoxButton, routineImageView, titleLabel].forEach { contentView.addSubview($0) }
    }
    
    override func configureLayout() {
        checkBoxButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.size.equalTo(24)
        }
        
        routineImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(checkBoxButton.snp.trailing).offset(12)
            make.size.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(routineImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().offset(-16)
        }
    }
    
    func configure(title: String, imageName: String, isSelected: Bool) {
        titleLabel.text = title
        routineImageView.image = UIImage(systemName: imageName)?.withRenderingMode(.alwaysTemplate)
        checkBoxButton.isSelected = isSelected
    }
    
    func toggleCheckBox() {
        checkBoxButton.isSelected.toggle()
    }
}
