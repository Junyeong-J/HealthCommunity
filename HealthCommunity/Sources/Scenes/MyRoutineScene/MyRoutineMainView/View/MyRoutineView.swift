//
//  MyRoutineView.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/23/24.
//

import UIKit
import SnapKit
import FSCalendar

final class MyRoutineView: BaseView {
    
    let segmentedControl: UISegmentedControl = {
        let items = ["내 운동 기록", "그래프로 보기"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    
    let calendarView : FSCalendar = {
        let calendar = FSCalendar(frame: .zero)
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.scope = .month
        
        calendar.appearance.headerDateFormat = "YYYY년 MM월"
        calendar.appearance.headerTitleAlignment = .center
        calendar.headerHeight = 45
        
        calendar.appearance.eventDefaultColor = UIColor.green
        calendar.appearance.eventSelectionColor = UIColor.green
        return calendar
    }()
    
    let activityButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("오늘 운동 기록하기", for: .normal)
        button.backgroundColor = .myAppMain
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    
    let graphView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let myRoutineView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let todayDataView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 10
        return view
    }()
    
    let summaryLabel: UILabel = {
        let label = UILabel()
        label.font = Font.regular13
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    let myRoutineDetailTableView: UITableView = {
        let view = UITableView()
        view.register(MyRoutineResultTableViewCell.self, forCellReuseIdentifier: MyRoutineResultTableViewCell.identifier)
        view.rowHeight = 140
        view.separatorStyle = .singleLine
        return view
    }()
    
    override func configureHierarchy() {
        [segmentedControl, calendarView, graphView,
         activityButton, myRoutineView].forEach { addSubview($0) }
        myRoutineView.addSubview(myRoutineDetailTableView)
        addSubview(todayDataView)
        [summaryLabel].forEach { todayDataView.addSubview($0) }
    }
    
    override func configureLayout() {
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        calendarView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(10)
            make.height.equalTo(300)
        }
        
        graphView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(10)
            make.height.equalTo(300)
        }
        
        myRoutineView.snp.makeConstraints { make in
            make.top.equalTo(todayDataView.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        myRoutineDetailTableView.snp.makeConstraints { make in
            make.edges.equalTo(myRoutineView)
        }
        
        activityButton.snp.makeConstraints { make in
            make.top.equalTo(calendarView.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(50)
            make.height.equalTo(50)
        }
        
        todayDataView.snp.makeConstraints { make in
            make.top.equalTo(graphView.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        summaryLabel.snp.makeConstraints { make in
            make.edges.equalTo(todayDataView).inset(10)
        }
        
        updateView(index: segmentedControl.selectedSegmentIndex)
    }
    
    func updateView(index: Int) {
        if (index == 0) {
            calendarView.isHidden = false
            graphView.isHidden = true
            myRoutineView.isHidden = true
            activityButton.isHidden = false
            todayDataView.isHidden = true
        } else {
            calendarView.isHidden = true
            graphView.isHidden = false
            myRoutineView.isHidden = true
            activityButton.isHidden = true
            todayDataView.isHidden = true
        }
    }
    
    func isRoutineView(_ isCollect: Bool) {
        myRoutineView.isHidden = !isCollect
        activityButton.isHidden = isCollect
        activityButton.isEnabled = !isCollect
        todayDataView.isHidden = !isCollect
    }
    
    func updateContentView(steps: String, distance: String, calories: String, standTime: String) {
        summaryLabel.text = "걸음: \(steps), 거리: \(distance)km, 칼로리: \(calories)kcal, 서 있기시간: \(standTime)분"
    }
    
}

extension MyRoutineView: NaviProtocol {
    var navigationTitle: String {
        return NavigationTitle.myToutine.title
    }
}
