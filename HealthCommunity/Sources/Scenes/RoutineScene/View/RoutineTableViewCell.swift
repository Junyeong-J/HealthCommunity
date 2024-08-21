//
//  RoutineTableViewCell.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/21/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

protocol RoutineTableViewCellDelegate: AnyObject {
    func didToggleCheckBox(item: RoutineRoutineItem, isSelected: Bool)
}

final class RoutineTableViewCell: BaseTableViewCell {
    
    private var disposeBag = DisposeBag()
    weak var delegate: RoutineTableViewCellDelegate?
    private var item: RoutineRoutineItem?
    
    
    private let titleLabel = UILabel()
    private let countTextField1 = UITextField()
    private let countTextField2 = UITextField()
    private let countTextField3 = UITextField()
    private let orderLabel = UILabel()
    private let routineImageView = UIImageView(image: UIImage(systemName: "star"))
    let checkBox = UIButton(type: .system)
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override func configureHierarchy() {
        [checkBox, routineImageView, titleLabel, countTextField1, countTextField2, countTextField3, orderLabel].forEach {
            contentView.addSubview($0)
        }
        configureCheckBox()
    }
    
    override func configureLayout() {
        checkBox.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        routineImageView.snp.makeConstraints { make in
            make.leading.equalTo(checkBox.snp.trailing).offset(5)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(routineImageView.snp.trailing).offset(5)
            make.centerY.equalToSuperview()
        }
        
        orderLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
        }
        
        countTextField1.snp.makeConstraints { make in
            make.trailing.equalTo(countTextField2.snp.leading).offset(-10)
            make.centerY.equalToSuperview()
            make.width.equalTo(50)
        }
        
        countTextField2.snp.makeConstraints { make in
            make.trailing.equalTo(countTextField3.snp.leading).offset(-10)
            make.centerY.equalToSuperview()
            make.width.equalTo(50)
        }
        
        countTextField3.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview()
            make.width.equalTo(50)
        }
    }
    
    func configureData(item: RoutineRoutineItem) {
        self.item = item
        titleLabel.text = item.title
        countTextField1.placeholder = "세트"
        countTextField2.placeholder = "횟수"
        countTextField3.placeholder = "중량(Kg)"
        updateCheckBoxState(isSelected: false)
    }
    
    private func configureCheckBox() {
        checkBox.layer.borderWidth = 2
        checkBox.layer.cornerRadius = 4
        checkBox.layer.borderColor = UIColor.blue.cgColor
        checkBox.backgroundColor = .white
        
        checkBox.setImage(nil, for: .normal)
        checkBox.setImage(UIImage(systemName: "checkmark"), for: .selected)
        checkBox.tintColor = .white
        
        checkBox.rx.tap
            .bind(with: self, onNext: { owner, _ in
                owner.checkBox.isSelected.toggle()
                owner.updateCheckBoxState(isSelected: owner.checkBox.isSelected)
                
                if let item = owner.item {
                    owner.delegate?.didToggleCheckBox(item: item, isSelected: owner.checkBox.isSelected)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func updateCheckBoxState(isSelected: Bool) {
        checkBox.backgroundColor = isSelected ? .blue : .white
        checkBox.layer.borderColor = isSelected ? UIColor.blue.cgColor : UIColor.gray.cgColor
        checkBox.tintColor = isSelected ? .black : .clear
    }
}
