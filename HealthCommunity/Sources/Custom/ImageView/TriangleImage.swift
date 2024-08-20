//
//  TriangleImage.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/20/24.
//

import UIKit

class TriangleImage: UIImageView {
    
    init() {
        super.init(frame: .zero)
        image = UIImage(systemName: "triangle.fill")?.withRenderingMode(.alwaysTemplate)
        tintColor = .black
        transform = CGAffineTransform(rotationAngle: .pi / 2)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
