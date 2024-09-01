//
//  LikeRoutineView.swift
//  HealthCommunity
//
//  Created by 전준영 on 9/1/24.
//

import UIKit
import SnapKit

final class LikeRoutineView: BaseView {
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(LikeRoutineTableViewCell.self, forCellReuseIdentifier: LikeRoutineTableViewCell.identifier)
        tableView.register(LikeRoutineHeaderView.self, forHeaderFooterViewReuseIdentifier: "HeaderView")
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    override func configureHierarchy() {
        addSubview(tableView)
    }
    
    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
