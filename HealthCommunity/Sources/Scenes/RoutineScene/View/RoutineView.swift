//
//  RoutineView.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/21/24.
//

import UIKit
import SnapKit

final class RoutineView: BaseView {
    
    let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
        collectionView.register(RoutineCollectionViewCell.self, forCellWithReuseIdentifier: RoutineCollectionViewCell.identifier)
        return collectionView
    }()
    
    static func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 80, height: 40)
        layout.scrollDirection = .horizontal
        return layout
    }
    
    let tableView: UITableView = {
        let view = UITableView()
        view.register(RoutineTableViewCell.self, forCellReuseIdentifier: RoutineTableViewCell.identifier)
        view.backgroundColor = .white
        view.rowHeight = 80
        view.separatorStyle = .none
        return view
    }()
    
    let selectedRoutineCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 80, height: 30)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(RoutineSelectedCollectionViewCell.self, forCellWithReuseIdentifier: RoutineSelectedCollectionViewCell.identifier)
        return collectionView
    }()
    
    let completeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("루틴 완료", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()
    
    let bottomView = UIView()
    
    override func configureHierarchy() {
        [tableView, collectionView, bottomView].forEach { addSubview($0) }
        bottomView.addSubview(selectedRoutineCollectionView)
        bottomView.addSubview(completeButton)
    }
    
    override func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(50)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(bottomView.snp.top)
        }
        
        bottomView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
            make.height.equalTo(80)
        }
        
        selectedRoutineCollectionView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.height.equalTo(30)
            make.trailing.equalTo(completeButton.snp.leading).offset(-10)
        }
        
        completeButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(100)
        }
    }
}
