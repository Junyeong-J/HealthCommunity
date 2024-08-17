//
//  PasswordSecureButton.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/17/24.
//

import UIKit

class PasswordSecureButton: UIButton {
    
    init() {
        super.init(frame: .zero)
        
        setTitle("보기", for: .normal)
        setTitleColor(.myAppGray, for: .normal)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
