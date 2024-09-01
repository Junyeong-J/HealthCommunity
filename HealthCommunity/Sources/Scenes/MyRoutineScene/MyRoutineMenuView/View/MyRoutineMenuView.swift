//
//  MyRoutineMenuView.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/26/24.
//

import UIKit
import SnapKit

final class MyRoutineMenuView: BaseView {
    
    let tableView: UITableView = {
        let view = UITableView()
        view.register(MyRoutineMenuTableViewCell.self, forCellReuseIdentifier: MyRoutineMenuTableViewCell.identifier)
        view.rowHeight = 50
        view.separatorStyle = .none
        return view
    }()
    
    let myRoutineDetailTableView: UITableView = {
        let view = UITableView()
        view.register(MyRoutineDetailTableViewCell.self, forCellReuseIdentifier: MyRoutineDetailTableViewCell.identifier)
        view.rowHeight = 140
        view.separatorStyle = .singleLine
        return view
    }()
    
    let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("오늘 운동 등록하기", for: .normal)
        button.backgroundColor = .myAppMain
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    
    let healthDataView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = 8
        return view
    }()
    
    let healthDataLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘: 0걸음, 0km, 0칼로리, 0분 서 있기"
        label.textAlignment = .center
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    override func configureHierarchy() {
        [tableView, addButton,
         myRoutineDetailTableView, healthDataView].forEach { addSubview($0) }
        healthDataView.addSubview(healthDataLabel)
    }
    
    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(100)
        }
        
        healthDataView.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        healthDataLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        addButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(50)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-10)
        }
        
        myRoutineDetailTableView.snp.makeConstraints { make in
            make.top.equalTo(healthDataView.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(addButton.snp.top).offset(-10)
        }
    }
}
