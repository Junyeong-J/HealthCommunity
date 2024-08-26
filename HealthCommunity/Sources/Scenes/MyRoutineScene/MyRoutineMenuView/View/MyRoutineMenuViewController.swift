//
//  MyRoutineMenuViewController.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/26/24.
//

import UIKit
import RxSwift
import RxCocoa

final class MyRoutineMenuViewController: BaseViewController<MyRoutineMenuView> {
    
    private let viewModel = MyRoutineMenuViewModel()
    private let selectedDate: String
    
    init(date: String) {
        self.selectedDate = date
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = selectedDate
    }
    
    override func bindModel() {
        let input = MyRoutineMenuViewModel.Input(
            itemSelected: rootView.tableView.rx.itemSelected,
            addButtonTapped: rootView.addButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        output.menuItems
            .drive(rootView.tableView.rx.items(
                cellIdentifier: MyRoutineMenuTableViewCell.identifier,
                cellType: MyRoutineMenuTableViewCell.self)) { row, item, cell in
                    cell.configure(data: item)
                }
                .disposed(by: viewModel.disposeBag)
        
        output.itemSelected
            .drive(with: self, onNext: { owner, indexPath in
                switch indexPath.row {
                case 0:
                    print(indexPath)
                case 1:
                    owner.navigationController?.pushViewController(HealthDataViewController(dateString: owner.selectedDate), animated: true)
                default:
                    break
                }
            })
            .disposed(by: viewModel.disposeBag)
        
        output.addButtonTapped
            .drive(onNext: {
                print("Add button tapped")
            })
            .disposed(by: viewModel.disposeBag)
    }
    
}
