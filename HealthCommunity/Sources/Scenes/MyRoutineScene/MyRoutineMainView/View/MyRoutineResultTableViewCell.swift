//
//  MyRoutineResultTableViewCell.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/29/24.
//

import UIKit
import SnapKit

final class MyRoutineResultTableViewCell: BaseTableViewCell {
    
    let numberLabel = UILabel()
    let bodyPartLabel = UILabel()
    let routineNameLabel = UILabel()
    let setLabel = UILabel()
    let weightLabel = UILabel()
    let countLabel = UILabel()
    
    override func configureHierarchy() {
        [numberLabel, bodyPartLabel, routineNameLabel, setLabel, weightLabel, countLabel].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func configureLayout() {
        numberLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(10)
        }
        
        bodyPartLabel.snp.makeConstraints { make in
            make.leading.equalTo(numberLabel.snp.trailing).offset(10)
            make.top.equalTo(numberLabel)
        }
        
        routineNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(bodyPartLabel.snp.trailing).offset(10)
            make.top.equalTo(numberLabel)
        }
        
        setLabel.snp.makeConstraints { make in
            make.top.equalTo(bodyPartLabel.snp.bottom).offset(5)
            make.leading.equalTo(bodyPartLabel)
        }
        
        weightLabel.snp.makeConstraints { make in
            make.top.equalTo(setLabel)
            make.leading.equalTo(setLabel.snp.trailing).offset(10)
        }
        
        countLabel.snp.makeConstraints { make in
            make.top.equalTo(setLabel)
            make.leading.equalTo(weightLabel.snp.trailing).offset(10)
        }
    }
    
    func configureData(number: Int, routine: Routines) {
        numberLabel.text = "\(number)번"
        bodyPartLabel.text = routine.bodyPart
        routineNameLabel.text = routine.routineName
        setLabel.text = "세트: \(routine.set)"
        weightLabel.text = "중량: \(routine.weight)"
        countLabel.text = "횟수: \(routine.count)"
    }
}

