//
//  EditProfileViewController.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/24/24.
//

import UIKit
import PhotosUI
import RxSwift
import RxCocoa

final class EditProfileViewController: BaseViewController<EditProfileView> {
    
    private let viewModel = EditProfileViewModel()
    private let profileImage = BehaviorSubject<UIImage?>(value: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        super.configureView()
    }
    
    override func bindModel() {
        let input = EditProfileViewModel.Input(
            galleryButtonTap: rootView.editProfileButton.rx.tap,
            saveButtonTap: rootView.saveButton.rx.tap,
            nick: rootView.nicknameTextField.rx.text.orEmpty.asObservable(),
            introduction: rootView.introduceTextField.rx.text.orEmpty.asObservable(),
            bench: rootView.benchTextField.rx.text.orEmpty.asObservable(),
            squat: rootView.squatTextField.rx.text.orEmpty.asObservable(),
            deadlift: rootView.deadliftTextField.rx.text.orEmpty.asObservable(),
            profileImage: profileImage.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.galleryButtonTapped
            .bind(with: self) { owner, _ in
                owner.openGallery()
            }
            .disposed(by: viewModel.disposeBag)
        
        output.saveButtonResult
            .bind(with: self) { owner, success in
                if success {
                    print("Profile updated successfully.")
                } else {
                    print("Failed to update profile.")
                }
            }
            .disposed(by: viewModel.disposeBag)
    }
    
}

extension EditProfileViewController {
    private func openGallery() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
}

extension EditProfileViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (object, error) in
                if let image = object as? UIImage {
                    DispatchQueue.main.async {
                        self?.profileImage.onNext(image)
                        self?.rootView.handleImage(image: image)
                    }
                }
            }
        }
    }
}
