//
//  WODViewController.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/19/24.
//

import UIKit
import PhotosUI
import RxSwift
import RxCocoa

final class WODViewController: BaseViewController<WODView>, RoutineViewControllerDelegate {
    
    func routineViewController(_ controller: RoutineViewController, didCompleteWith selectedItems: [RoutineRoutineItem]) {
        self.selectedItems.accept(selectedItems)
        print("Selected items: \(selectedItems.map { $0.title })")
    }
    
    private let viewModel = WODViewModel()
    private let selectedItems = PublishRelay<[RoutineRoutineItem]>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        super.configureView()
    }
    
    override func bindModel() {
        
        let input = WODViewModel.Input(
            albumButtonTap: rootView.photoButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        output.albumButtonTapped
            .bind(with: self) { owner, _ in
                owner.openGallery()
            }
            .disposed(by: viewModel.disposeBag)
        
        output.tableList
            .bind(to: rootView.tableView.rx.items(
                cellIdentifier: WODTableViewCell.identifier,
                cellType: WODTableViewCell.self)) { (row, element, cell) in
                    cell.configureData(title: element)
                }
                .disposed(by: viewModel.disposeBag)
        
        
        rootView.tableView.rx.itemSelected
            .subscribe(with: self) { owner, indexPath in
                switch indexPath.row {
                case 0:
                    let detailVC = RoutineViewController()
                    detailVC.delegate = self
                    owner.navigationController?.pushViewController(detailVC, animated: true)
                case 1:
                    let detailVC = RoutineViewController()
                    owner.navigationController?.pushViewController(detailVC, animated: true)
                case 2:
                    let detailVC = RoutineViewController()
                    owner.navigationController?.pushViewController(detailVC, animated: true)
                case 3:
                    let detailVC = RoutineViewController()
                    owner.navigationController?.pushViewController(detailVC, animated: true)
                default:
                    break
                }
            }
            .disposed(by: viewModel.disposeBag)
        
    }
    
}

extension WODViewController {
    private func openGallery() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 5
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
}

extension WODViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (object, error) in
                if let image = object as? UIImage {
                    DispatchQueue.main.async {
                        self?.rootView.addImageView(image: image)
                    }
                }
            }
        }
    }
}
