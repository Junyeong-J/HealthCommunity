//
//  MyRoutineSelectView.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/27/24.
//

import UIKit
import SnapKit

final class MyRoutineSelectView: BaseView {
    
    let searchView = UISearchBar()
    
    private let fitnessTitles = ["하체", "가슴", "등", "어깨", "팔", "역도", "복근", "기타", "유산소"]
    
    let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
        collectionView.register(FitnessAreaCollectionViewCell.self, forCellWithReuseIdentifier: FitnessAreaCollectionViewCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    static func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width: 60, height: 36)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        return layout
    }
    
    let tableView: UITableView = {
        let view = UITableView()
        view.register(MyRoutineSelectTableViewCell.self, forCellReuseIdentifier: MyRoutineSelectTableViewCell.identifier)
        view.backgroundColor = .white
        view.rowHeight = 80
        view.separatorStyle = .none
        return view
    }()
    
    override func configureHierarchy() {
        [searchView, collectionView, tableView].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        searchView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(42)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(5)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
}
