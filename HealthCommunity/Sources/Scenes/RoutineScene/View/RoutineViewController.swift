//
//  RoutineViewController.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/21/24.
//

import UIKit
import RxSwift
import RxCocoa


protocol RoutineViewControllerDelegate: AnyObject {
    func routineViewController(_ controller: RoutineViewController, didCompleteWith selectedItems: [RoutineRoutineItem])
}

final class RoutineViewController: BaseViewController<RoutineView> {
    
    private let viewModel = RoutineViewModel()
    weak var delegate: RoutineViewControllerDelegate?
    
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
        
        Observable.combineLatest(output.routineItems, output.selectedRoutineType)
            .map { routineItems, selectedRoutineType in
                routineItems.map { routineItem in
                    let routineType = RoutineType(rawValue: routineItem) ?? .legs
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
                cellType: RoutineTableViewCell.self)) { [weak self] row, item, cell in
                    cell.configureData(item: item)
                    cell.delegate = self
                }
                .disposed(by: viewModel.disposeBag)
        
        output.selectedCount
            .map { "\($0) 개 선택됨" }
            .bind(to: rootView.completeButton.rx.title(for: .normal))
            .disposed(by: viewModel.disposeBag)
        
        rootView.completeButton.rx.tap
            .withLatestFrom(output.selectedItemsRelay)
            .bind(with: self, onNext: { owner, items in
                owner.delegate?.routineViewController(owner, didCompleteWith: items)
                owner.navigationController?.popViewController(animated: true)
            })
            .disposed(by: viewModel.disposeBag)
    }
}

extension RoutineViewController: RoutineTableViewCellDelegate {
    func didToggleCheckBox(item: RoutineRoutineItem, isSelected: Bool) {
        
        print("\(item.title), \(isSelected)")
        viewModel.updateSelectedItems(item: item, isSelected: isSelected)
    }
}

