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
    
    override func configureHierarchy() {
        [tableView, collectionView].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(50)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(50)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
