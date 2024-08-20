//
//  RoutineTableViewCell.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/21/24.
//

import UIKit
import SnapKit

final class RoutineTableViewCell: BaseTableViewCell {
    
    private let titleLabel = UILabel()
    private let countTextField1 = UITextField()
    private let countTextField2 = UITextField()
    
    override func configureHierarchy() {
        [titleLabel, countTextField1, countTextField2].forEach { contentView.addSubview($0) }
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
        }
        
        countTextField1.snp.makeConstraints { make in
            make.trailing.equalTo(countTextField2.snp.leading).offset(-10)
            make.centerY.equalToSuperview()
            make.width.equalTo(50)
        }
        
        countTextField2.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview()
            make.width.equalTo(50)
        }
    }
    
    func configureData(title: String) {
            titleLabel.text = title
            countTextField1.placeholder = "세트"
            countTextField2.placeholder = "횟수"
        }
    
}
