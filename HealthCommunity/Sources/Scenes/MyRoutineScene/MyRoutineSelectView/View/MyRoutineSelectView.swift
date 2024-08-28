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
        view.backgroundColor = .myAppWhite
        view.rowHeight = 80
        view.separatorStyle = .none
        return view
    }()
    
    private let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .myAppWhite
        view.layer.shadowColor = UIColor.myAppBlack.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: -2)
        view.layer.shadowRadius = 4
        return view
    }()
    
    let selectButton = BaseButton(title: .seleteCheck)
    
    let selectedCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: selectedlayout())
        collectionView.register(SelectedRoutineCollectionViewCell.self, forCellWithReuseIdentifier: SelectedRoutineCollectionViewCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    static func selectedlayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width: 100, height: 30)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        return layout
    }
    
    override func configureHierarchy() {
        [searchView, collectionView, tableView, bottomView].forEach { addSubview($0) }
        bottomView.addSubview(selectedCollectionView)
        bottomView.addSubview(selectButton)
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
            make.bottom.equalTo(bottomView.snp.top)
        }
        
        bottomView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(70)
        }
        
        selectedCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(0)
        }
        
        selectButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(selectedCollectionView.snp.bottom).offset(5)
            make.height.equalTo(50)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
    }
    
    func viewHeight(isExpand: Bool) {
        bottomView.snp.updateConstraints { make in
            make.height.equalTo(isExpand ? 100 : 70)
        }
        selectedCollectionView.snp.updateConstraints { make in
            make.height.equalTo(isExpand ? 30 : 0)
        }
        layoutIfNeeded()
    }
}
