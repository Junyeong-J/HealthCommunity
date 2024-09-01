//
//  LikeRoutineViewController.swift
//  HealthCommunity
//
//  Created by 전준영 on 9/1/24.
//

import UIKit
import RxSwift
import RxCocoa

final class LikeRoutineViewController: BaseViewController<LikeRoutineView> {
    
    private let viewModel = LikeRoutineViewModel()
    private var likeList: [(Creator, [RoutinDetail])] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bindModel() {
        let input = LikeRoutineViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.groupedLikeList
            .subscribe(onNext: { [weak self] data in
                self?.likeList = data
                self?.rootView.tableView.reloadData()
            })
            .disposed(by: viewModel.disposeBag)
        
        rootView.tableView.dataSource = self
        rootView.tableView.delegate = self
    }
    
}

extension LikeRoutineViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return likeList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return likeList[section].1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LikeRoutineTableViewCell.identifier, for: indexPath) as! LikeRoutineTableViewCell
        let routine = likeList[indexPath.section].1[indexPath.row]
        cell.configure(with: routine, order: indexPath.row + 1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderView") as! LikeRoutineHeaderView
        let creator = likeList[section].0
        header.configure(with: creator)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 150
    }
}
