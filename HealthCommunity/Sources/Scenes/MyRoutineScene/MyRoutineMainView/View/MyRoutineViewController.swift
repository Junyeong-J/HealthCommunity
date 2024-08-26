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
    
    private var selectedDate: String = "" {
        didSet {
            updateTitleButton()
            selectedDateRelay.accept(selectedDate)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rootView.calendarView.delegate = self
        selectedDate = FormatterManager.shared.formatCalendarDate(Date())
    }
    
    override func configureView() {
        super.configureView()
        rootView.segmentedControl.selectedSegmentIndex = 0
        rootView.updateView(for: 0)
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
    }
    
}

extension MyRoutineViewController {
    
    private func updateTitleButton() {
        rootView.activityButton.setTitle(selectedDate, for: .normal)
    }
    
}

extension MyRoutineViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = FormatterManager.shared.formatCalendarDate(date)
    }
}
