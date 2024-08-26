//
//  SendButton.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/25/24.
//

import UIKit

class SendButton: UIButton {
    
    init(title: ButtonTitle) {
        super.init(frame: .zero)
        
        setTitle(title.rawValue, for: .normal)
        setTitleColor(.white, for: .normal)
        backgroundColor = .myAppMain
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
