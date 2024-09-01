//
//  ToggleDetailView.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/25/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ToggleDetailView: UIView {
    
    private let disposeBag = DisposeBag()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    private let toggleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return button
    }()
    
    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.systemRed, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.isHidden = true
        return button
    }()
    
    private var isExpand = false
    private var storedText: String?
    private let viewText: String
    private let hideText: String?

    init(title: String, viewText: String, hideText: String?, actionButtonText: String? = nil, actionButtonImage: UIImage? = nil) {
        self.viewText = viewText
        self.hideText = hideText
        super.init(frame: .zero)
        
        self.backgroundColor = UIColor(white: 0.95, alpha: 1.0) // 연한 회색 배경
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        
        titleLabel.text = title
        
        if let buttonText = actionButtonText {
            actionButton.setTitle(buttonText, for: .normal)
            if let image = actionButtonImage {
                actionButton.setImage(image, for: .normal)
                actionButton.tintColor = .systemRed
                actionButton.semanticContentAttribute = .forceRightToLeft
                actionButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
            }
            actionButton.isHidden = false
        }
        
        configureHierarchy()
        configureLayout()
        configureBindings()
        
        toggleButton.setTitle(viewText, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy() {
        [titleLabel, contentLabel, toggleButton, actionButton].forEach { addSubview($0) }
    }
    
    private func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(12)
        }
        
        toggleButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().inset(12)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(toggleButton.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(12)
        }
        
        actionButton.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview().inset(12)
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
        toggleButton.setTitle(viewText, for: .normal)
    }
    
    private func toggleContent() {
        isExpand.toggle()
        toggleButton.setTitle(isExpand ? (hideText ?? "숨기기") : viewText, for: .normal)
        
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

