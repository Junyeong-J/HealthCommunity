//
//  OpponentProfileImage.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/22/24.
//

import UIKit

class OpponentProfileImage: UIImageView {
    
    init() {
        super.init(frame: .zero)
        image = UIImage(systemName: "star")?.withRenderingMode(.alwaysTemplate)
        tintColor = .black
        contentMode = .scaleAspectFill
        clipsToBounds = true
        layer.cornerRadius = 20
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.myAppGray.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
