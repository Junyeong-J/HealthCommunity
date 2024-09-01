//
//  IconManager.swift
//  HealthCommunity
//
//  Created by 전준영 on 9/1/24.
//

import UIKit

struct IconManager {
    static let iconNames = [
        "figure.walk",
        "figure.jumprope",
        "figure.strengthtraining.traditional",
        "dumbbell",
        "dumbbell.fill",
        "figure.strengthtraining.functional"
    ]
    
    static func createIconImageViews(tintColor: UIColor = .myAppBlack, contentMode: UIView.ContentMode = .scaleAspectFit) -> [UIImageView] {
        return iconNames.map {
            let imageView = UIImageView(image: UIImage(systemName: $0))
            imageView.tintColor = tintColor
            imageView.contentMode = contentMode
            return imageView
        }
    }
}
