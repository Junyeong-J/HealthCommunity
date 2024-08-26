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
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    
    let graphView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let distanceLabel: UILabel = {
        let label = UILabel()
        label.text = "0 km"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        return label
    }()
    
    override func configureHierarchy() {
        [segmentedControl, calendarView, graphView,
         activityButton, distanceLabel].forEach { addSubview($0) }
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
        
        activityButton.snp.makeConstraints { make in
            make.top.equalTo(calendarView.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(50)
            make.height.equalTo(50)
        }
        
        distanceLabel.snp.makeConstraints { make in
            make.top.equalTo(activityButton.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        updateView(for: segmentedControl.selectedSegmentIndex)
    }
    
    func updateView(for index: Int) {
        let isCalendarViewVisible = (index == 0)
        calendarView.isHidden = !isCalendarViewVisible
        graphView.isHidden = isCalendarViewVisible
    }
}

