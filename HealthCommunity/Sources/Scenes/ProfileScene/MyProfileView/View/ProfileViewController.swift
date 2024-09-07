//
//  ProfileViewController.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/23/24.
//

import UIKit
import RxSwift
import RxCocoa

final class ProfileViewController: BaseViewController<ProfileView> {
    
    private let viewModel = ProfileViewModel()
    private var userProfile: UserProfile?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeProfileUpdateNotification()
    }
    
    override func configureView() {
        super.configureView()
    }
    
    override func bindModel() {
        let input = ProfileViewModel.Input(
            editProfileTap: rootView.profileEditButton.rx.tap,
            routineLikeTap: rootView.routineLikesButton.rx.tap,
            logoutTap: rootView.logoutButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        output.myProfileList
            .bind(with: self, onNext: { owner, profile in
                owner.userProfile = profile.first
                owner.rootView.configureData(profile: profile)
            })
            .disposed(by: viewModel.disposeBag)
        
        output.editProfileTapped
            .bind(with: self) { owner, _ in
                if let profile = owner.userProfile {
                    owner.navigationController?.pushViewController(EditProfileViewController(profile: profile), animated: true)
                }
            }
            .disposed(by: viewModel.disposeBag)
        
        output.routineLikeTapped
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(LikeRoutineViewController(), animated: true)
            }
            .disposed(by: viewModel.disposeBag)
        
        output.logoutTapped
            .bind(with: self) { owner, _ in
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                let sceneDelegate = windowScene?.delegate as? SceneDelegate
                
                let rootViewController = LoginViewController()
                sceneDelegate?.window?.rootViewController = rootViewController
                sceneDelegate?.window?.makeKeyAndVisible()
            }
            .disposed(by: viewModel.disposeBag)
        
    }
    
}

extension ProfileViewController {
    
    private func observeProfileUpdateNotification() {
        NotificationCenter.default.rx.notification(Notification.Name("profileDidUpdate"))
            .bind(with: self, onNext: { owner, _ in
                owner.viewModel.fetchProfileData()
            })
            .disposed(by: viewModel.disposeBag)
    }
    
}
