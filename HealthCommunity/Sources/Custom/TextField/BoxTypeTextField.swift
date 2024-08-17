//
//  BoxTypeTextField.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/17/24.
//

import UIKit

class BoxTypeTextField: UITextField {
    
    init(style: TextFieldPlaceholder) {
        super.init(frame: .zero)
        placeholder = style.rawValue
        borderStyle = .roundedRect
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
