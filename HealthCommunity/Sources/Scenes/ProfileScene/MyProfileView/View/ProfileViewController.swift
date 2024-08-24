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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        super.configureView()
    }
    
    override func bindModel() {
        let input = ProfileViewModel.Input()
        
        let output = viewModel.transform(input: input)
        
        output.menuItems
            .drive(rootView.tableView.rx.items(
                cellIdentifier: ProfileListTableViewCell.identifier,
                cellType: ProfileListTableViewCell.self)) { row, item, cell in
                    cell.configure(with: item)
                }
                .disposed(by: viewModel.disposeBag)
        
        output.myProfileList
            .bind(with: self, onNext: { owner, profile in
                owner.rootView.configureData(profile: profile)
            })
            .disposed(by: viewModel.disposeBag)
        
        rootView.tableView.rx.modelSelected(String.self)
            .bind(with: self, onNext: { owner, item in
                switch item {
                case "프로필 수정":
                    print("프로필 수정 화면으로 이동")
                case "루틴 좋아요 목록":
                    print("루틴 좋아요 목록 화면으로 이동")
                case "목표 정하기":
                    print("목표 정하기 화면으로 이동")
                case "탈퇴":
                    print("탈퇴 화면으로 이동")
                default:
                    break
                }
            })
            .disposed(by: viewModel.disposeBag)
    }
    
}
