//
//  LikeRoutineTableViewCell.swift
//  HealthCommunity
//
//  Created by 전준영 on 9/1/24.
//

import UIKit
import SnapKit

final class LikeRoutineTableViewCell: BaseTableViewCell {
    
    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 5
        return view
    }()
    
    private let orderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        label.backgroundColor = .systemBlue
        label.textAlignment = .center
        label.layer.cornerRadius = 13
        label.clipsToBounds = true
        return label
    }()
    
    private let routineTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    private let routineDetailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.numberOfLines = 0
        return label
    }()
    
    override func configureHierarchy() {
        contentView.addSubview(cardView)
        cardView.addSubview(orderLabel)
        cardView.addSubview(routineTitleLabel)
        cardView.addSubview(routineDetailLabel)
    }
    
    override func configureLayout() {
        cardView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        orderLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(15)
            make.width.height.equalTo(26)
        }
        
        routineTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.leading.equalTo(orderLabel.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-15)
        }
        
        routineDetailLabel.snp.makeConstraints { make in
            make.top.equalTo(routineTitleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(15)
            make.bottom.equalToSuperview().offset(-15)
        }
    }
    
    func configure(with routine: RoutinDetail, order: Int) {
        orderLabel.text = "\(order)"
        routineTitleLabel.text = "\(routine.category) | \(routine.name)"
        routineDetailLabel.text = "\(routine.sets)세트 \(routine.weight)KG, \(routine.reps)회"
    }
}

