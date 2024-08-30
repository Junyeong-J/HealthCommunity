//
//  ShadowRoundedView.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/30/24.
//

import UIKit

final class ShadowRoundedView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    
    private func configureView() {
        layer.cornerRadius = 10
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
    }
}
