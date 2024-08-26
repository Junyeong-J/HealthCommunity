//
//  MyProfileImageView.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/24/24.
//

import UIKit

class MyProfileImageView: UIImageView {
    
    init() {
        super.init(frame: .zero)
        contentMode = .scaleAspectFill
        layer.cornerRadius = 75
        clipsToBounds = true
        layer.borderWidth = 2.0
        layer.borderColor = UIColor.myAppGray.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
