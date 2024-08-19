//
//  CameraButton.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/19/24.
//

import UIKit

class CameraButton: UIButton {
    
    init() {
        super.init(frame: .zero)
        
        configureButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CameraButton {
    private func configureButton() {
        backgroundColor = .myAppWhite
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .light)
        setImage(UIImage(systemName: "camera", withConfiguration: imageConfig)?.withTintColor(.myAppBlack, renderingMode: .alwaysOriginal), for: .normal)
        imageView?.contentMode = .scaleAspectFit

        layer.shadowColor = UIColor.black.cgColor
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.3
        layer.cornerRadius = 20
    }
}
