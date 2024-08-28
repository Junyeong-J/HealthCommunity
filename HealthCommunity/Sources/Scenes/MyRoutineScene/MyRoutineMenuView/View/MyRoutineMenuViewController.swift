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
    
    private let content = BehaviorSubject<String>(value: "")
    private var myRoutineDetail = BehaviorSubject<[String: [String]]>(value: [:])
    private var healthData = BehaviorSubject<String>(value: "오늘: 0걸음, 0km, 0칼로리, 0분 서 있기")
    
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
        notificationSelectedMyRoutine()
        notificationHealthKitData()
        setupTapGestureToDismissKeyboard()
    }
    
    private func setupTapGestureToDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboards))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboards() {
        view.endEditing(true)
    }
    
    override func bindModel() {
        let input = MyRoutineMenuViewModel.Input(
            itemSelected: rootView.tableView.rx.itemSelected,
            routineData: myRoutineDetail.asObserver(),
            healthData: healthData.asObserver(),
            addButtonTapped: rootView.addButton.rx.tap,
            contentData: content.asObserver()
        )
        
        let output = viewModel.transform(input: input)
        
        output.menuItems
            .drive(rootView.tableView.rx.items(
                cellIdentifier: MyRoutineMenuTableViewCell.identifier,
                cellType: MyRoutineMenuTableViewCell.self)) { row, item, cell in
                    cell.configure(data: item)
                }
                .disposed(by: viewModel.disposeBag)
        
        rootView.myRoutineDetailTableView.rx
            .willDisplayCell
            .compactMap { $0.cell as? MyRoutineDetailTableViewCell }
            .bind(with: self, onNext: { owner, cell in
                cell.textFieldChanges
                    .bind(onNext: { routineName, set, weight, count in
                        var newContentArray = [String]()
                        for i in 0..<self.rootView.myRoutineDetailTableView.numberOfRows(inSection: 0) {
                            if let cell = self.rootView.myRoutineDetailTableView.cellForRow(at: IndexPath(row: i, section: 0)) as? MyRoutineDetailTableViewCell {
                                let routineData = cell.getRoutineData()
                                let routineString = "\(routineData.routineName) [세트: \(routineData.set ?? ""), 중량: \(routineData.weight ?? ""), 횟수: \(routineData.count ?? "")]"
                                newContentArray.append(routineString)
                            }
                        }
                        let newContent = newContentArray.joined(separator: ", ")
                        self.content.onNext(newContent)
                    })
                    .disposed(by: cell.disposeBag)
            })
            .disposed(by: viewModel.disposeBag)
        
        output.itemSelected
            .drive(with: self, onNext: { owner, indexPath in
                switch indexPath.row {
                case 0:
                    let myRoutines = try? owner.myRoutineDetail.value()
                    let routineSelectVC = MyRoutineSelectViewController(selectedMyRoutine: myRoutines)
                    owner.navigationController?.pushViewController(routineSelectVC, animated: true)
                case 1:
                    owner.navigationController?.pushViewController(HealthDataViewController(dateString: owner.selectedDate), animated: true)
                default:
                    break
                }
            })
            .disposed(by: viewModel.disposeBag)
        
        output.routineList
            .flatMap { routines -> Observable<[(String, String)]> in
                var allRoutines: [(String, String)] = []
                routines.forEach { category, routineList in
                    routineList.forEach { routine in
                        allRoutines.append((category, routine))
                    }
                }
                return Observable.just(allRoutines)
            }
            .bind(to: rootView.myRoutineDetailTableView.rx.items(
                cellIdentifier: MyRoutineDetailTableViewCell.identifier,
                cellType: MyRoutineDetailTableViewCell.self)) { index, element, cell in
                    let category = element.0
                    let routine = element.1
                    cell.configure(routine: "\(category)| \(routine)")
                }
                .disposed(by: viewModel.disposeBag)
        
        output.addButtonTapped
            .bind(with: self, onNext: { owner, value in
                if value {
                    owner.navigationController?.popViewController(animated: true)
                } else {
                    print(value)
                }
            })
            .disposed(by: viewModel.disposeBag)
        
        output.healthData
            .bind(to: rootView.healthDataLabel.rx.text)
            .disposed(by: viewModel.disposeBag)
    }
    
}

extension MyRoutineMenuViewController {
    private func notificationSelectedMyRoutine() {
        NotificationCenter.default.rx
            .notification(NSNotification.Name("SelectedMyRoutine"))
            .compactMap { $0.object as? [String: [String]] }
            .asDriver(onErrorDriveWith: .empty())
            .drive(with: self, onNext: { owner, selectedRoutines in
                owner.myRoutineDetail.onNext(selectedRoutines)
            })
            .disposed(by: viewModel.disposeBag)
    }
    
    private func notificationHealthKitData() {
        NotificationCenter.default.rx
            .notification(NSNotification.Name("HealthMyRoutine"))
            .asDriver(onErrorDriveWith: .empty())
            .drive(with: self, onNext: { owner, notification in
                guard let healthData = notification.object as? String else {
                    print("Health Data가 유효하지 않습니다.")
                    return
                }
                owner.healthData.onNext(healthData)
            })
            .disposed(by: viewModel.disposeBag)
    }
    
}
