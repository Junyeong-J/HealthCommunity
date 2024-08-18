//
//  OnBoardingViewController.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/15/24.
//

import UIKit
import RxSwift

final class OnBoardingViewController: BaseViewController<OnBoardingView> {
    
    private let viewModel = OnBoardingViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        super.configureView()
    }
    
    override func bindModel() {
        let input = OnBoardingViewModel.Input(
            startButtonTap: rootView.startButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.startButtonTapped
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(LoginViewController(), animated: true)
            }
            .disposed(by: disposeBag)
    }
    
}
