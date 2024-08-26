//
//  BoxTypeProfileTextField.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/24/24.
//

import UIKit

class BoxTypeProfileTextField: UITextField {
    
    init(style: TextFieldPlaceholder) {
        super.init(frame: .zero)
        placeholder = style.rawValue
        borderStyle = .roundedRect
        textAlignment = .center
        font = Font.regular16
        layer.cornerRadius = 8
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 1.0
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowRadius = 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
