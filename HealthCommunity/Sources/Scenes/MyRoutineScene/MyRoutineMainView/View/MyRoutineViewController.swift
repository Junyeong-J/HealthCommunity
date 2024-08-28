//
//  MyRoutineViewController.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/23/24.
//

import UIKit
import RxSwift
import RxCocoa
import FSCalendar

final class MyRoutineViewController: BaseViewController<MyRoutineView> {
    
    private let viewModel = MyRoutineViewModel()
    private let selectedDateRelay = BehaviorRelay<String>(value: "")
    private var eventDates: Set<Date> = []
    
    private var selectedDate: String = "" {
        didSet {
            updateTitleButton()
            selectedDateRelay.accept(selectedDate)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        super.configureView()
        rootView.segmentedControl.selectedSegmentIndex = 0
        rootView.updateView(for: 0)
        
        rootView.calendarView.delegate = self
        rootView.calendarView.dataSource = self
        
        selectedDate = FormatterManager.shared.formatCalendarDate(Date())
        rootView.calendarView.appearance.eventDefaultColor = UIColor.green
        rootView.calendarView.appearance.eventSelectionColor = UIColor.green
    }
    
    override func bindModel() {
        let input = MyRoutineViewModel.Input(
            selectedSegmentIndex: rootView.segmentedControl.rx.selectedSegmentIndex,
            recordButtonTap: rootView.activityButton.rx.tap,
            selectedDate: selectedDateRelay.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.selectedSegmentIndexTap
            .drive(with: self, onNext: { owner, index in
                owner.rootView.updateView(for: index)
            })
            .disposed(by: viewModel.disposeBag)
        
        output.recordButtonTapped
            .bind(with: self) { owner, date in
                owner.navigationController?.pushViewController(MyRoutineMenuViewController(date: date), animated: true)
            }
            .disposed(by: viewModel.disposeBag)
        
        output.myList
            .bind(with: self) { owner, posts in
                owner.setEvents(posts: posts)
            }
            .disposed(by: viewModel.disposeBag)
    }
    
}

extension MyRoutineViewController {
    
    private func updateTitleButton() {
        rootView.activityButton.setTitle(selectedDate, for: .normal)
    }
    
    private func setEvents(posts: [Post]) {
        let events = posts.compactMap { post -> Date? in
            return FormatterManager.shared.formatStringToDate(post.title ?? "")
        }
        eventDates = Set(events)
        rootView.calendarView.reloadData()
    }
}

extension MyRoutineViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = FormatterManager.shared.formatCalendarDate(date)
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        if self.eventDates.contains(date){
            return 1
        }
        return 0
    }
}
