//
//  MainView.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/18/24.
//

import UIKit
import SnapKit

final class MainView: BaseView {
    
    let segmentControl: UISegmentedControl = {
        let segment = UISegmentedControl()
        segment.insertSegment(withTitle: "오운완", at: 0, animated: true)
        segment.insertSegment(withTitle: "피드벡", at: 1, animated: true)
        segment.insertSegment(withTitle: "소통", at: 2, animated: true)
        segment.selectedSegmentIndex = 0
        return segment
    }()
    
    let wodTableView: UITableView = {
        let view = UITableView()
        view.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.identifier)
        view.backgroundColor = .red
        view.rowHeight = 400
        view.separatorStyle = .none
        return view
    }()
    
    let feedbackTableView: UITableView = {
        let view = UITableView()
        view.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.identifier)
        view.backgroundColor = .green
        view.rowHeight = 400
        view.separatorStyle = .none
        return view
    }()
    
    let communicationTableView: UITableView = {
        let view = UITableView()
        view.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.identifier)
        view.backgroundColor = .blue
        view.rowHeight = 400
        view.separatorStyle = .none
        return view
    }()
    
    let postButton = PostButton()
    
    override func configureHierarchy() {
        [segmentControl, wodTableView,
         feedbackTableView, communicationTableView,
         postButton].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        segmentControl.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(10)
            make.height.equalTo(30)
        }
        
        wodTableView.snp.makeConstraints { make in
            make.top.equalTo(segmentControl.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        feedbackTableView.snp.makeConstraints { make in
            make.edges.equalTo(wodTableView)
        }
        
        communicationTableView.snp.makeConstraints { make in
            make.edges.equalTo(wodTableView)
        }
        
        postButton.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(safeAreaLayoutGuide).inset(10)
            make.height.equalTo(50)
            make.width.equalTo(120)
        }
    }
    
    override func configureView() {
        wodTableView.isHidden = false
        feedbackTableView.isHidden = true
        communicationTableView.isHidden = true
    }
    
    func updateSegmentTableView(index: Int) {
        wodTableView.isHidden = index != 0
        feedbackTableView.isHidden = index != 1
        communicationTableView.isHidden = index != 2
    }
    
}
