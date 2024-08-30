//
//  HealthClassView.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/23/24.
//

import UIKit
import SnapKit

final class HealthClassView: BaseView {
    
    let locationPicker: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "이번달 클래스"
        label.font = Font.bold25
        label.textColor = .myAppBlack
        label.textAlignment = .left
        return label
    }()
    
    let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
        collectionView.register(HealthClassCollectionViewCell.self, forCellWithReuseIdentifier: HealthClassCollectionViewCell.identifier)
        return collectionView
    }()
    
    static func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let sectionSpacing: CGFloat = 20
        let cellSpacing: CGFloat = 16
        let numberOfItemsPerRow: CGFloat = 2
        let availableWidth = UIScreen.main.bounds.width - (sectionSpacing * 2) - (cellSpacing * (numberOfItemsPerRow - 1))
        let cellWidth = availableWidth / numberOfItemsPerRow
        
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth * 1.6)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = cellSpacing
        layout.minimumInteritemSpacing = cellSpacing
        layout.sectionInset = UIEdgeInsets(top: sectionSpacing, left: sectionSpacing, bottom: sectionSpacing, right: sectionSpacing)
        
        return layout
    }
    
    
    override func configureHierarchy() {
        [locationPicker, titleLabel,
         collectionView].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        locationPicker.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
            make.horizontalEdges.equalToSuperview().inset(10)
            make.height.equalTo(50)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(locationPicker.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(10)
            make.height.equalTo(50)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
    func updateTitleLabel(with location: String) {
        titleLabel.text = "\(location) 지역 이번달 클래스"
    }
}


