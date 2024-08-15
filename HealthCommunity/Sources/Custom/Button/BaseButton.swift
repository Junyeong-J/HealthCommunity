//
//  BaseButton.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/15/24.
//

import UIKit

class BaseButton: UIButton {
    
    init(title: ButtonTitle) {
        super.init(frame: .zero)
        
        setTitle(title.rawValue, for: .normal)
        setTitleColor(.myAppWhite, for: .normal)
        layer.cornerRadius = 25
        backgroundColor = .myAppMain
        titleLabel?.font = Font.bold18
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
