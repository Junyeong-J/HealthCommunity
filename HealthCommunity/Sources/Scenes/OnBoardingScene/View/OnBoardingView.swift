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
    
    override func configureHierarchy() {
        addSubview(startButton)
    }
    
    override func configureLayout() {
        startButton.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
    }
    
}
