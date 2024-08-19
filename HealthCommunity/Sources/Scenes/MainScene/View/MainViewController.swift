//
//  MainViewController.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/18/24.
//

import UIKit
import RxSwift
import RxCocoa

final class MainViewController: BaseViewController<MainView> {
    
    private let viewModel = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bindModel() {
        let input = MainViewModel.Input(
            postButtonTap: rootView.postButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        output.postButtonTapped
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(WODViewController(), animated: true)
            }
            .disposed(by: viewModel.disposeBag)
    }
    
}
