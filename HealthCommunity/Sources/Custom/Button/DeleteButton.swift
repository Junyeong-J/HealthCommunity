//
//  DeleteButton.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/28/24.
//

import UIKit

class DeleteButton: UIButton {
    
    init() {
        super.init(frame: .zero)
        
        setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        tintColor = .myAppMain
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
