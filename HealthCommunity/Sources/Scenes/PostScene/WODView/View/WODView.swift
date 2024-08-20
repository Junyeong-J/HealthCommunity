//
//  WODView.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/19/24.
//

import UIKit
import SnapKit

final class WODView: BaseView {
    
    let topHeight = UIScreen.main.bounds.height * 0.20
    let contentHeight = UIScreen.main.bounds.height * 0.30
    let actionButtonHeight: CGFloat = 50
    let spacing: CGFloat = 20
    
    private let photoLabel: UILabel = {
        let label = UILabel()
        label.text = "사진 선택"
        label.font = Font.bold17
        return label
    }()
    
    let photoScrollView = UIScrollView()
    let photoButton = CameraButton()
    var imageViews: [UIImageView] = []
    
    let contentTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.myAppGray.cgColor
        textView.layer.cornerRadius = 10
        return textView
    }()
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "오운완 내용 적어주세요 :)"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.lightGray
        label.isHidden = false
        return label
    }()
    
    let tableView: UITableView = {
        let view = UITableView()
        view.register(WODTableViewCell.self, forCellReuseIdentifier: WODTableViewCell.identifier)
        view.backgroundColor = .white
        view.rowHeight = (UIScreen.main.bounds.height * 0.20) / 4
        view.separatorStyle = .none
        view.isScrollEnabled = false
        return view
    }()
    
    let actionButton = BaseButton(title: .post)
    
    override func configureHierarchy() {
        [photoLabel, photoScrollView, contentTextView, placeholderLabel, tableView, actionButton].forEach { addSubview($0) }
        photoScrollView.addSubview(photoButton)
    }
    
    override func configureLayout() {
        
        photoLabel.snp.makeConstraints { make in
            make.leading.top.equalTo(safeAreaLayoutGuide).inset(15)
        }
        
        photoScrollView.snp.makeConstraints { make in
            make.top.equalTo(photoLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(15)
            make.height.equalTo(topHeight - 40)
        }
        
        photoButton.snp.makeConstraints { make in
            make.size.equalTo(80)
            make.centerY.equalTo(photoScrollView)
            make.leading.equalTo(photoScrollView).inset(5)
        }
        
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(photoScrollView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(15)
            make.height.equalTo(contentHeight - 40)
        }
        
        placeholderLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentTextView).inset(5)
            make.top.equalTo(contentTextView).inset(8)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(contentTextView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(15)
            make.bottom.equalTo(actionButton.snp.top).offset(-20)
        }
        
        actionButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).inset(15)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(15)
            make.height.equalTo(actionButtonHeight)
        }
        
        contentTextView.delegate = self
    }
    
    func addImageView(image: UIImage) {
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        imageViews.append(imageView)
        
        setupPhotoScrollView()
    }
    
    private func setupPhotoScrollView() {
        let stackView = UIStackView(arrangedSubviews: imageViews)
        stackView.axis = .horizontal
        stackView.spacing = 10
        
        photoScrollView.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.leading.equalTo(photoButton.snp.trailing).offset(10)
            make.centerY.equalTo(photoButton)
            make.height.equalTo(80)
        }
        
        imageViews.forEach { imageView in
            imageView.snp.makeConstraints { make in
                make.size.equalTo(80)
            }
        }
        
        let totalWidth = CGFloat(imageViews.count * 80) + CGFloat((imageViews.count) * 10) + 80 + 15
        photoScrollView.contentSize = CGSize(width: totalWidth, height: 80)
    }
}

extension WODView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}
