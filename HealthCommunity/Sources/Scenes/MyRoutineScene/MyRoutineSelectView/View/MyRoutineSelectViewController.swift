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
    private let checkBoxRow = PublishSubject<Int>()
    private let deleteRoutineIndex = PublishSubject<Int>()
    private var initRoutines: [String: [String]]?
    
    init(selectedMyRoutine: [String: [String]]? = nil) {
        self.initRoutines = selectedMyRoutine
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rootView.collectionView.selectItem(at: selectedIndex, animated: false, scrollPosition: [])
        viewModel.loadData()
        
        if let routines = initRoutines {
            viewModel.initSelectedRoutines(routines)
        }
    }
    
    override func bindModel() {
        let input = MyRoutineSelectViewModel.Input(
            itemSelected: rootView.collectionView.rx.itemSelected,
            checkBoxToggled: checkBoxRow.asObservable(),
            deleteRoutine: deleteRoutineIndex.asObservable(),
            selectedButtonTap: rootView.selectButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        output.fitnessAreas
            .drive(rootView.collectionView.rx.items(
                cellIdentifier: FitnessAreaCollectionViewCell.identifier,
                cellType: FitnessAreaCollectionViewCell.self)) { [weak self] index, title, cell in
                    let isSelected = (self?.selectedIndex?.row == index)
                    cell.configure(title: title, isSelected: isSelected)
                }
                .disposed(by: viewModel.disposeBag)
        
        output.routines
            .bind(to: rootView.tableView.rx.items(
                cellIdentifier: MyRoutineSelectTableViewCell.identifier,
                cellType: MyRoutineSelectTableViewCell.self)) { [weak self] row, routine, cell in
                    
                    cell.configure(title: routine.name, imageName: routine.routineImageName, isSelected: routine.isSelected)
                    
                    cell.checkBoxButton.rx.tap
                        .subscribe(onNext: { _ in
                            cell.toggleCheckBox()
                            self?.checkBoxRow.onNext(row)
                        })
                        .disposed(by: cell.disposeBag)
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
        
        output.selectedRoutines
            .bind(to: rootView.selectedCollectionView.rx.items(
                cellIdentifier: SelectedRoutineCollectionViewCell.identifier,
                cellType: SelectedRoutineCollectionViewCell.self)) { [weak self] index, routine, cell in
                    cell.configure(title: routine.name)
                    
                    cell.deleteButton.rx.tap
                        .subscribe(onNext: {
                            self?.deleteRoutineIndex.onNext(index)
                        })
                        .disposed(by: cell.disposeBag)
                }
                .disposed(by: viewModel.disposeBag)
        
        output.selectedRoutines
            .bind(with: self, onNext: { owner, routines in
                let isExpand = !routines.isEmpty
                owner.rootView.viewHeight(isExpand: isExpand)
            })
            .disposed(by: viewModel.disposeBag)
        
        output.buttonTitle
            .bind(to: rootView.selectButton.rx.title(for: .normal))
            .disposed(by: viewModel.disposeBag)
        
        output.selectedButtonTapped
            .bind(with: self, onNext: { owner, myRoutines in
                NotificationCenter.default.post(name: NSNotification.Name("SelectedMyRoutine"), object: myRoutines)
                owner.navigationController?.popViewController(animated: true)
            })
            .disposed(by: viewModel.disposeBag)
    }
    
}
