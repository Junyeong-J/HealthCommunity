//
//  WODView.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/19/24.
//

import UIKit
import SnapKit

final class WODView: BaseView {
    
    private let WODPostScrollView = UIScrollView()
    private let contentView = UIView()
    
    private let photoLabel: UILabel = {
        let label = UILabel()
        label.text = "사진 선택"
        label.font = Font.bold17
        return label
    }()
    
    private let photoScrollView = UIScrollView()
    
    let photoButton = CameraButton()
    
    override func configureHierarchy() {
        addSubview(WODPostScrollView)
        WODPostScrollView.addSubview(contentView)
        
        [photoLabel, photoScrollView].forEach { contentView.addSubview($0) }
        photoScrollView.addSubview(photoButton)
        
    }
    
    override func configureLayout() {
        WODPostScrollView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.width.equalTo(WODPostScrollView.snp.width)
            make.verticalEdges.equalTo(WODPostScrollView)
        }
        
        photoLabel.snp.makeConstraints { make in
            make.leading.top.equalTo(contentView).inset(15)
        }
        
        photoScrollView.snp.makeConstraints { make in
            make.top.equalTo(photoLabel.snp.bottom).offset(5)
            make.trailing.equalTo(contentView.snp.trailing).offset(-5)
            make.leading.equalTo(photoLabel)
            make.height.equalTo(100)
        }
        
        photoButton.snp.makeConstraints { make in
            make.size.equalTo(80)
            make.centerY.equalTo(photoScrollView)
            make.leading.equalTo(photoScrollView).inset(5)
        }
        
    }

    
}
