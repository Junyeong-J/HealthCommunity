//
//  MyRoutineResultTableViewCell.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/29/24.
//

import UIKit
import SnapKit

final class MyRoutineResultTableViewCell: BaseTableViewCell {
    
    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 5
        return view
    }()
    
    private let numberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .white
        label.backgroundColor = .systemBlue
        label.textAlignment = .center
        label.layer.cornerRadius = 15
        label.clipsToBounds = true
        return label
    }()
    
    private let routineTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    private let detailStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    private let setLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        return label
    }()
    
    private let weightLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        return label
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        return label
    }()
    
    override func configureHierarchy() {
        contentView.addSubview(cardView)
        cardView.addSubview(numberLabel)
        cardView.addSubview(routineTitleLabel)
        cardView.addSubview(detailStackView)
        
        [setLabel, weightLabel, countLabel].forEach { detailStackView.addArrangedSubview($0) }
    }
    
    override func configureLayout() {
        cardView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        numberLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(10)
            make.width.height.equalTo(30)
        }
        
        routineTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(numberLabel.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(10)
            make.top.equalToSuperview().inset(10)
        }
        
        detailStackView.snp.makeConstraints { make in
            make.leading.equalTo(routineTitleLabel)
            make.top.equalTo(routineTitleLabel.snp.bottom).offset(10)
            make.trailing.bottom.equalToSuperview().inset(10)
        }
    }
    
    func configureData(number: Int, routine: Routines) {
        numberLabel.text = "\(number)"
        routineTitleLabel.text = "\(routine.bodyPart) | \(routine.routineName)"
        setLabel.text = "세트: \(routine.set)세트"
        weightLabel.text = "중량: \(routine.weight)kg"
        countLabel.text = "횟수: \(routine.count)회"
    }
}
