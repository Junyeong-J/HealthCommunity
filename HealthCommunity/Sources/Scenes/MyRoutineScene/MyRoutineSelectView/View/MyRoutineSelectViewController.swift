//
//  MyRoutineSelectViewController.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/27/24.
//

import UIKit
import RxSwift
import RxCocoa

final class MyRoutineSelectViewController: BaseViewController<MyRoutineSelectView> {
    
    private let viewModel = MyRoutineSelectViewModel()
    private var selectedIndex: IndexPath? = IndexPath(item: 0, section: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bindModel() {
        let input = MyRoutineSelectViewModel.Input(
            itemSelected: rootView.collectionView.rx.itemSelected)
        
        let output = viewModel.transform(input: input)
        
        output.fitnessAreas
            .drive(rootView.collectionView.rx.items(
                cellIdentifier: FitnessAreaCollectionViewCell.identifier,
                cellType: FitnessAreaCollectionViewCell.self)) { [weak self] index, title, cell in
                    let isSelected = (self?.selectedIndex?.row == index)
                    cell.configure(with: title, isSelected: isSelected)
                }
                .disposed(by: viewModel.disposeBag)
        
        output.routines
            .drive(rootView.tableView.rx.items(
                cellIdentifier: MyRoutineSelectTableViewCell.identifier,
                cellType: MyRoutineSelectTableViewCell.self)) { index, routine, cell in
                    let imageName = self.viewModel.iconName(for: self.selectedIndex?.row ?? 0)
                    cell.configure(with: routine, imageName: imageName, isChecked: false)
                }
                .disposed(by: viewModel.disposeBag)
        
        output.itemSelected
            .drive(with: self, onNext: { owner, indexPath in
                if let previousIndexPath = owner.selectedIndex,
                   let previousCell = owner.rootView.collectionView.cellForItem(at: previousIndexPath) as? FitnessAreaCollectionViewCell {
                    previousCell.contentView.backgroundColor = .myAppWhite
                    previousCell.titleLabel.textColor = .myAppBlack
                }
                if let cell = owner.rootView.collectionView.cellForItem(at: indexPath) as? FitnessAreaCollectionViewCell {
                    cell.contentView.backgroundColor = .myAppMain
                    cell.titleLabel.textColor = .myAppWhite
                }
                owner.selectedIndex = indexPath
            })
            .disposed(by: viewModel.disposeBag)
    }
}
