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

final class WODViewController: BaseViewController<WODView> {
    
    private let viewModel = WODViewModel()
    
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
