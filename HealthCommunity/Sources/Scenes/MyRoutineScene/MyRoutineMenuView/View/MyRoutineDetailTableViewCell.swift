//
//  MyRoutineDetailTableViewCell.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/28/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class MyRoutineDetailTableViewCell: BaseTableViewCell {
    
    private let textFieldWidth = (UIScreen.main.bounds.width - 40 - 60) / 3
    private let labelTextFieldOffset: CGFloat = 5
    
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    private let containView: UIView = {
        let view = UIView()
        view.layer.shadowColor = UIColor.myAppBlack.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.layer.cornerRadius = 8
        view.backgroundColor = .myAppWhite
        return view
    }()
    
    private let routineTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    private let setLabel: UILabel = {
        let label = UILabel()
        label.text = "세트"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    private let weightLabel: UILabel = {
        let label = UILabel()
        label.text = "kg"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.text = "횟수"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    private let weightTextField: BoxTypeTextField = {
        let textField = BoxTypeTextField(style: .weight)
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private let setsTextField: BoxTypeTextField = {
        let textField = BoxTypeTextField(style: .set)
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private let countTextField: BoxTypeTextField = {
        let textField = BoxTypeTextField(style: .count)
        textField.keyboardType = .numberPad
        return textField
    }()
    
    override func configureHierarchy() {
        contentView.addSubview(containView)
        [routineTitleLabel, setLabel, weightLabel, countLabel,
         setsTextField, weightTextField, countTextField].forEach { containView.addSubview($0) }
    }
    
    override func configureLayout() {
        containView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        
        routineTitleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        
        
        setLabel.snp.makeConstraints { make in
            make.top.equalTo(routineTitleLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(16)
        }
        
        setsTextField.snp.makeConstraints { make in
            make.top.equalTo(setLabel.snp.bottom).offset(labelTextFieldOffset)
            make.leading.equalTo(setLabel.snp.leading)
            make.width.equalTo(textFieldWidth)
            make.height.equalTo(30)
        }
        
        weightLabel.snp.makeConstraints { make in
            make.top.equalTo(setLabel.snp.top)
            make.leading.equalTo(setsTextField.snp.trailing).offset(20)
        }
        
        weightTextField.snp.makeConstraints { make in
            make.top.equalTo(weightLabel.snp.bottom).offset(labelTextFieldOffset)
            make.leading.equalTo(weightLabel.snp.leading)
            make.width.equalTo(textFieldWidth)
            make.height.equalTo(30)
        }
        
        countLabel.snp.makeConstraints { make in
            make.top.equalTo(weightLabel.snp.top)
            make.leading.equalTo(weightTextField.snp.trailing).offset(20)
        }
        
        countTextField.snp.makeConstraints { make in
            make.top.equalTo(countLabel.snp.bottom).offset(labelTextFieldOffset)
            make.leading.equalTo(countLabel.snp.leading)
            make.width.equalTo(textFieldWidth)
            make.height.equalTo(30)
            make.bottom.equalToSuperview().offset(-16)
        }
    }
    
    func configure(routine: String) {
        routineTitleLabel.text = routine
    }
    
    func getRoutineData() -> (routineName: String, set: String?, weight: String?, count: String?) {
        let routineName = routineTitleLabel.text ?? ""
        let set = setsTextField.text
        let weight = weightTextField.text
        let count = countTextField.text
        return (routineName, set, weight, count)
    }
}

