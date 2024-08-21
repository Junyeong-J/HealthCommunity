//
//  RoutineViewController.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/21/24.
//

import UIKit
import RxSwift
import RxCocoa

final class RoutineViewController: BaseViewController<RoutineView> {
    
    private let viewModel = RoutineViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        super.configureView()
    }
    
    override func bindModel() {
        let input = RoutineViewModel.Input(
            routineTypeSelection: rootView.collectionView.rx
                .modelSelected(RoutineType.self)
                .asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        // Combine latest selectedRoutineType with routineItems and map to (title, isSelected) tuple
        Observable.combineLatest(output.routineItems, output.selectedRoutineType)
            .map { routineItems, selectedRoutineType in
                routineItems.map { routineItem in
                    let routineType = RoutineType(rawValue: routineItem) ?? .legs // 기본값으로 legs 설정
                    return (routineItem, routineType == selectedRoutineType)
                }
            }
            .bind(to: rootView.collectionView.rx.items(
                cellIdentifier: RoutineCollectionViewCell.identifier,
                cellType: RoutineCollectionViewCell.self)) { row, element, cell in
                    let (title, isSelected) = element
                    cell.configure(title: title, isSelected: isSelected)
                }
                .disposed(by: viewModel.disposeBag)
        
        output.items
            .bind(to: rootView.tableView.rx.items(
                cellIdentifier: RoutineTableViewCell.identifier,
                cellType: RoutineTableViewCell.self)) { row, item, cell in
                    cell.configureData(item: item)
                }
                .disposed(by: viewModel.disposeBag)
    }
}

