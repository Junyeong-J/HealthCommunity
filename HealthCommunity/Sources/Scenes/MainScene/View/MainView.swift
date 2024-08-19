//
//  MainView.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/18/24.
//

import UIKit
import SnapKit

final class MainView: BaseView {
    
    let postButton = PostButton()
    
    override func configureHierarchy() {
        addSubview(postButton)
    }
    
    override func configureLayout() {
        postButton.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(safeAreaLayoutGuide).inset(10)
            make.height.equalTo(50)
            make.width.equalTo(120)
        }
    }
    
}
