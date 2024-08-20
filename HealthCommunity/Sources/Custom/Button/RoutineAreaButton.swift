//
//  RoutineAreaButton.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/21/24.
//

import UIKit

class RoutineAreaButton: UIButton {
    
    init() {
        super.init(frame: .zero)
        
        configureButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension RoutineAreaButton {
    private func configureButton() {
        var configuration = UIButton.Configuration.filled()
        
        configuration.baseForegroundColor = .myAppBlack
        configuration.baseBackgroundColor = .myAppWhite
        configuration.cornerStyle = .medium
        
        configuration.background.strokeColor = .myAppBlack
        configuration.background.strokeWidth = 1
        
        self.configuration = configuration
        
        self.clipsToBounds = true
        
        self.setTitle("Test", for: .normal)
        self.titleLabel?.font = Font.bold16
    }
}
