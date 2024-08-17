//
//  NicknameViewController.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/17/24.
//

import UIKit
import RxSwift
import RxCocoa

final class NicknameViewController: BaseViewController<NicknameView> {
    
    private let viewModel = NicknameViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        super.configureView()
    }
    
    override func bindModel() {
        let input = NicknameViewModel.Input(
            nicknameText: rootView.nicknameInputTextField.rx.text
        )
        
        let output = viewModel.transform(input: input)
        
        output.isButtonEnabled
            .drive(rootView.joinCompletebt.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.isButtonEnabled
            .map { $0 ? .myAppMain : .myAppGray }
            .drive(rootView.joinCompletebt.rx.backgroundColor)
            .disposed(by: disposeBag)
    }
    
}
