//
//  UIButton+Extension.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/27/24.
//

import UIKit

extension UIButton.Configuration {
    
    static func circleStyle(title: String) -> UIButton.Configuration {
        var configuration = UIButton.Configuration.plain()
        configuration.title = title
        configuration.titleAlignment = .center
        configuration.baseBackgroundColor = .myAppWhite
        configuration.baseForegroundColor = .myAppGray
        configuration.cornerStyle = .capsule
        return configuration
    }
    
}
