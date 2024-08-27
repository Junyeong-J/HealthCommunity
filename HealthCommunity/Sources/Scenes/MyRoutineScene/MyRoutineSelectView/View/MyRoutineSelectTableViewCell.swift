//
//  MyRoutineSelectTableViewCell.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/27/24.
//

import UIKit
import SnapKit

final class MyRoutineSelectTableViewCell: BaseTableViewCell {
    
    private let checkBox: UIButton = {
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
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    override func configureHierarchy() {
        contentView.addSubview(checkBox)
        contentView.addSubview(routineImageView)
        contentView.addSubview(titleLabel)
    }
    
    override func configureLayout() {
        checkBox.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.size.equalTo(24)
        }
        
        routineImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(checkBox.snp.trailing).offset(12)
            make.size.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(routineImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().offset(-16)
        }
    }
    
    func configure(with title: String, imageName: String, isChecked: Bool) {
        titleLabel.text = title
        routineImageView.image = UIImage(systemName: imageName)?.withRenderingMode(.alwaysTemplate)
        checkBox.isSelected = isChecked
    }
    
    func toggleCheckBox() {
        checkBox.isSelected.toggle()
    }
}
