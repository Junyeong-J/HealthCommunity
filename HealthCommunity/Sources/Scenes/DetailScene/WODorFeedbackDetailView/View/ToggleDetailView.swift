//
//  WodToggleDetailView.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/25/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ToggleDetailView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Font.bold16
        label.textColor = .black
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = Font.regular14
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    private let toggleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("더보기", for: .normal)
        return button
    }()
    
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("", for: .normal)
        button.isHidden = true
        return button
    }()
    
    private var isExpand = false
    private var storedText: String?
    
    private let disposeBag = DisposeBag()
    
    init(title: String, buttonText: String?) {
        super.init(frame: .zero)
        
        titleLabel.text = title
        if let buttonText = buttonText {
            actionButton.setTitle(buttonText, for: .normal)
            actionButton.isHidden = false
        }
        
        configureHierarchy()
        configureLayout()
        configureBindings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy() {
        [titleLabel, contentLabel,
         toggleButton, actionButton].forEach { addSubview($0) }
    }
    
    private func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }
        
        toggleButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview()
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(toggleButton.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview()
        }
        
        actionButton.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(8)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    private func configureBindings() {
        toggleButton.rx.tap
            .bind(with: self, onNext: { owner, _ in
                owner.toggleContent()
            })
            .disposed(by: disposeBag)
    }
    
    func setContentText(_ text: String?) {
        storedText = text
        contentLabel.isHidden = true
        toggleButton.isHidden = false
        isExpand = false
        toggleButton.setTitle("더보기", for: .normal)
    }
    
    private func toggleContent() {
        isExpand.toggle()
        toggleButton.setTitle(isExpand ? "숨기기" : "더보기", for: .normal)
        
        if isExpand {
            contentLabel.text = storedText
        } else {
            contentLabel.text = ""
        }
        
        contentLabel.isHidden = !isExpand
        
        UIView.animate(withDuration: 0.3) {
            self.superview?.layoutIfNeeded()
        }
    }
}

