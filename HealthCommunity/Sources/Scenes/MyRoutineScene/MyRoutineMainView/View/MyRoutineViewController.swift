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
    
    private var selectedDate: Date = Date() {
        didSet {
            updateTitleButton()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configureView() {
        super.configureView()
        rootView.segmentedControl.selectedSegmentIndex = 0
        rootView.updateView(for: 0)
    }
    
    override func bindModel() {
        let input = MyRoutineViewModel.Input(
            selectedSegmentIndex: rootView.segmentedControl.rx.selectedSegmentIndex,
            recordButtonTap: rootView.activityButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        output.selectedSegmentIndexTap
            .drive(with: self, onNext: { owner, index in
                owner.rootView.updateView(for: index)
            })
            .disposed(by: viewModel.disposeBag)
        
        output.recordButtonTapped
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(MyRoutineMenuViewController(), animated: true)
            }
            .disposed(by: viewModel.disposeBag)
    }
    
}

extension MyRoutineViewController {
    
    private func updateTitleButton() {
        let formatter = DateFormatter()
        FormatterManager
        formatter.dateFormat = "MM월 dd일 운동 기록하기"
        let dateString = formatter.string(from: selectedDate)
        rootView.activityButton.setTitle(dateString, for: .normal)
    }
    
}

extension MyRoutineViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = date
    }
}
