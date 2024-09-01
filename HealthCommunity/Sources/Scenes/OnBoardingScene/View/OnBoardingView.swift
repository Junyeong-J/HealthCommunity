//
//  OnBoardingView.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/15/24.
//

import UIKit
import SnapKit

final class OnBoardingView: BaseView {
    
    let startButton = BaseButton(title: .start)
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "웨이트 하우스"
        label.font = Font.bold25
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    private let icons: [UIImageView] = IconManager.createIconImageViews()
    
    override func configureHierarchy() {
        addSubview(titleLabel)
        icons.forEach { addSubview($0) }
        addSubview(startButton)
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(100)
            make.centerX.equalToSuperview()
        }
        
        let iconPositions: [(xMultiplier: CGFloat, yMultiplier: CGFloat)] = [
            (1, 1),
            (1.7, 0.3),
            (0.5, 0.5),
            (0.3, 1.7),
            (1.7, 0.7),
            (1.3, 1.3)
        ]
        
        for (index, icon) in icons.enumerated() {
            let position = iconPositions[index % iconPositions.count]
            icon.snp.makeConstraints { make in
                make.centerX.equalToSuperview().multipliedBy(position.xMultiplier)
                make.centerY.equalToSuperview().multipliedBy(position.yMultiplier)
                make.size.equalTo(100)
            }
        }
        
        startButton.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
    }
}
