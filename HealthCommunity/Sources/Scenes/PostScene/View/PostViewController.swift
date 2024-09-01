//
//  PostViewController.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/31/24.
//

import UIKit
import RxSwift
import RxCocoa
import PhotosUI

final class PostViewController: BaseViewController<PostView> {
    
    private let viewModel = PostViewModel()
    
    private let content = BehaviorSubject<String>(value: "")
    private var myRoutineDetail = BehaviorSubject<[String: [String]]>(value: [:])
    private var healthData = BehaviorSubject<String>(value: "오늘: 0걸음, 0km, 0칼로리, 0분 서 있기")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationSelectedMyRoutine()
        notificationHealthKitData()
    }
    
    override func bindModel() {
        
        let input = PostViewModel.Input(
            onewonButtonTap: rootView.wodButton.rx.tap,
            routineData: myRoutineDetail.asObserver(),
            feedbackButtonTap: rootView.feedbackButton.rx.tap,
            communicationButtonTap: rootView.communicationButton.rx.tap,
            albumButtonTap: rootView.photoButton.rx.tap,
            contentData: content.asObserver(),
            healthData: healthData.asObserver(),
            postButtonTap: rootView.addButton.rx.tap,
            tableSize: rootView.myRoutineDetailTableView.rx,
            contentText: rootView.contentTextView.rx.text.orEmpty.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.selectedButtonIndex
            .drive(with: self) { owner, index in
                owner.rootView.updateButtonSelection(selectedIndex: index)
            }
            .disposed(by: viewModel.disposeBag)
        
        output.albumButtonTapped
            .drive(with: self) { owner, _ in
                owner.openGallery()
            }
            .disposed(by: viewModel.disposeBag)
        
        output.photos
            .drive(with: self) { owner, photos in
                owner.rootView.updatePhotoScrollView(with: photos)
            }
            .disposed(by: viewModel.disposeBag)
        
        rootView.removeImageAtIndex = { [weak self] index in
            self?.viewModel.removePhoto(at: index)
        }
        
        output.menuItems
            .drive(rootView.tableView.rx.items(
                cellIdentifier: MyRoutineMenuTableViewCell.identifier,
                cellType: MyRoutineMenuTableViewCell.self
            )) { row, item, cell in
                cell.configure(data: item)
            }
            .disposed(by: viewModel.disposeBag)
        
        rootView.myRoutineDetailTableView.rx
            .willDisplayCell
            .compactMap { $0.cell as? MyRoutineDetailTableViewCell }
            .bind(with: self, onNext: { owner, cell in
                cell.textFieldChanges
                    .bind(onNext: { routineName, set, weight, count in
                        var newContentArray = [[String]]()
                        
                        for i in 0..<self.rootView.myRoutineDetailTableView.numberOfRows(inSection: 0) {
                            if let cell = self.rootView.myRoutineDetailTableView.cellForRow(at: IndexPath(row: i, section: 0)) as? MyRoutineDetailTableViewCell {
                                let routineData = cell.getRoutineData()
                                let routineName = routineData.routineName
                                let set = routineData.set ?? ""
                                let weight = routineData.weight ?? ""
                                let count = routineData.count ?? ""
                                let routineArray = [routineName, set, weight, count]
                                newContentArray.append(routineArray)
                            }
                        }
                        let joinedContent = newContentArray.map { $0.joined(separator: ", ") }
                        let finalContent = joinedContent.joined(separator: "; ")
                        self.content.onNext(finalContent)
                    })
                    .disposed(by: cell.disposeBag)
            })
            .disposed(by: viewModel.disposeBag)
        
        rootView.tableView.rx.itemSelected
            .bind(with: self, onNext: { owner, indexPath in
                switch indexPath.row {
                case 0:
                    let myRoutines = try? owner.myRoutineDetail.value()
                    let routineSelectVC = MyRoutineSelectViewController(selectedMyRoutine: myRoutines)
                    owner.rootView.tableView.deselectRow(at: indexPath, animated: true)
                    owner.navigationController?.pushViewController(routineSelectVC, animated: true)
                case 1:
                    let currentDate = FormatterManager.shared.getCurrentDate()
                    let healthDataVC = PostHealthDataViewController(dateString: currentDate)
                    owner.rootView.tableView.deselectRow(at: indexPath, animated: true)
                    owner.navigationController?.pushViewController(healthDataVC, animated: true)
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
        
        output.healthData
            .bind(to: rootView.healthDataLabel.rx.text)
            .disposed(by: viewModel.disposeBag)
        
        output.postResult
            .drive(with: self) { owner, value in
                if value {
                    NotificationCenter.default.post(name: Notification.Name("postSuccess"), object: nil)
                    owner.navigationController?.popViewController(animated: true)
                } else {
                    print("error입니다")
                }
            }
            .disposed(by: viewModel.disposeBag)
        
        output.tableSizeOutput
            .bind(with: self) { owner, height in
                owner.updateTableViewHeight(height)
            }
            .disposed(by: viewModel.disposeBag)
        
    }
    
}

extension PostViewController {
    
    private func openGallery() {
        let remainingImages = 5 - rootView.imageViews.count
        guard remainingImages > 0 else { return }
        
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = remainingImages
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    private func updateTableViewHeight(_ height: CGFloat) {
        rootView.myRoutineDetailTableView.snp.updateConstraints { make in
            make.height.equalTo(height)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.rootView.layoutIfNeeded()
        }
    }
}

extension PostViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (object, error) in
                if let image = object as? UIImage {
                    DispatchQueue.main.async {
                        self?.viewModel.addPhoto(image)
                    }
                }
            }
        }
    }
}

extension PostViewController {
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
