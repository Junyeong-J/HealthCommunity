//
//  PostView.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/31/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class PostView: BaseView, UITextViewDelegate {
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    private let postTypeLabel: UILabel = {
        let label = UILabel()
        label.text = "게시글 종류"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .black
        return label
    }()
    
    let wodButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("오운완", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1.0
        return button
    }()
    
    let feedbackButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("피드백", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1.0
        return button
    }()
    
    let communicationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("소통", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1.0
        return button
    }()
    
    private let photoLabel: UILabel = {
        let label = UILabel()
        label.text = "사진 선택"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .black
        return label
    }()
    
    let photoScrollView = UIScrollView()
    let photoButton = CameraButton()
    var imageViews: [UIView] = []
    
    private let photoCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0/5"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    let contentTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.black.cgColor
        textView.layer.cornerRadius = 10
        return textView
    }()
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "내용을 적어주세요:)"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        label.isHidden = false
        return label
    }()
    
    let tableView: UITableView = {
        let view = UITableView()
        view.register(MyRoutineMenuTableViewCell.self, forCellReuseIdentifier: MyRoutineMenuTableViewCell.identifier)
        view.rowHeight = 50
        view.separatorStyle = .none
        return view
    }()
    
    let myRoutineDetailTableView: UITableView = {
        let view = UITableView()
        view.register(MyRoutineDetailTableViewCell.self, forCellReuseIdentifier: MyRoutineDetailTableViewCell.identifier)
        view.rowHeight = 140
        view.separatorStyle = .singleLine
        return view
    }()
    
    let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("글쓰기", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    
    let healthDataView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = 8
        return view
    }()
    
    let healthDataLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘: 0걸음, 0km, 0칼로리, 0분 서 있기"
        label.textAlignment = .center
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    override func configureHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(postTypeLabel)
        contentView.addSubview(wodButton)
        contentView.addSubview(feedbackButton)
        contentView.addSubview(communicationButton)
        contentView.addSubview(photoLabel)
        contentView.addSubview(photoScrollView)
        contentView.addSubview(photoCountLabel)
        contentView.addSubview(contentTextView)
        contentTextView.addSubview(placeholderLabel)
        photoScrollView.addSubview(photoButton)
        [tableView, addButton, healthDataView, myRoutineDetailTableView].forEach { contentView.addSubview($0) }
        healthDataView.addSubview(healthDataLabel)
    }
    
    override func configureLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.width.equalTo(scrollView.snp.width)
            make.verticalEdges.equalTo(scrollView)
        }
        
        postTypeLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(20)
            make.leading.equalToSuperview().offset(30)
        }
        
        let buttonWidth = (UIScreen.main.bounds.width - 80) / 3
        
        wodButton.snp.makeConstraints { make in
            make.top.equalTo(postTypeLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(15)
            make.width.equalTo(buttonWidth)
            make.height.equalTo(40)
        }
        
        feedbackButton.snp.makeConstraints { make in
            make.top.equalTo(wodButton)
            make.leading.equalTo(wodButton.snp.trailing).offset(10)
            make.width.equalTo(buttonWidth)
            make.height.equalTo(40)
        }
        
        communicationButton.snp.makeConstraints { make in
            make.top.equalTo(wodButton)
            make.leading.equalTo(feedbackButton.snp.trailing).offset(10)
            make.width.equalTo(buttonWidth)
            make.height.equalTo(40)
        }
        
        photoLabel.snp.makeConstraints { make in
            make.top.equalTo(wodButton.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(30)
        }
        
        photoScrollView.snp.makeConstraints { make in
            make.top.equalTo(photoLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(15)
            make.height.equalTo(100)
        }
        
        photoButton.snp.makeConstraints { make in
            make.size.equalTo(80)
            make.leading.equalTo(photoScrollView).offset(10)
            make.centerY.equalTo(photoScrollView)
        }
        
        photoCountLabel.snp.makeConstraints { make in
            make.top.equalTo(photoScrollView.snp.bottom).offset(5)
            make.leading.equalTo(photoScrollView.snp.leading)
        }
        
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(photoScrollView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(300)
        }
        
        placeholderLabel.snp.makeConstraints { make in
            make.top.equalTo(contentTextView).offset(8)
            make.leading.equalTo(contentTextView).offset(5)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(contentTextView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(contentView)
            make.height.equalTo(100)
        }
        
        healthDataView.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(contentView).inset(20)
            make.height.equalTo(50)
        }
        
        healthDataLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        addButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(contentView).inset(20)
            make.height.equalTo(50)
            make.bottom.equalTo(contentView.snp.bottom).offset(-10)
        }
        
        myRoutineDetailTableView.snp.makeConstraints { make in
            make.top.equalTo(healthDataView.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(contentView)
            make.bottom.equalTo(addButton.snp.top).offset(-10)
            make.height.equalTo(1)
        }
    }
    
    override func configureView() {
        setPhotoSelectionVisible(false)
        contentTextView.delegate = self
    }
    
    func setPhotoSelectionVisible(_ isVisible: Bool) {
        photoLabel.isHidden = !isVisible
        photoScrollView.isHidden = !isVisible
        photoCountLabel.isHidden = !isVisible
        tableView.isHidden = !isVisible
        myRoutineDetailTableView.isHidden = !isVisible
        healthDataView.isHidden = !isVisible
        
        if isVisible {
            contentTextView.snp.remakeConstraints { make in
                make.top.equalTo(photoCountLabel.snp.bottom).offset(20)
                make.leading.trailing.equalToSuperview().inset(20)
                make.height.equalTo(300)
            }
        } else {
            contentTextView.snp.remakeConstraints { make in
                make.top.equalTo(communicationButton.snp.bottom).offset(20)
                make.leading.trailing.equalToSuperview().inset(20)
                make.height.equalTo(300)
            }
        }
        
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    func updatePhotoScrollView(with photos: [UIImage]) {
        imageViews.forEach { $0.removeFromSuperview() }
        imageViews.removeAll()
        
        photos.enumerated().forEach { index, image in
            addImageView(image: image, index: index)
        }
        
        updatePhotoCount()
        setupPhotoScrollView()
    }
    
    func addImageView(image: UIImage, index: Int) {
        let containerView = UIView()
        containerView.layer.cornerRadius = 20
        containerView.clipsToBounds = true
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        containerView.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(containerView)
            make.size.equalTo(80)
        }
        
        let closeButton = UIButton(type: .custom)
        closeButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        closeButton.tintColor = .white
        closeButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        closeButton.layer.cornerRadius = 10
        closeButton.tag = index
        closeButton.addTarget(self, action: #selector(removeImageView(_:)), for: .touchUpInside)
        containerView.addSubview(closeButton)
        
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(containerView).offset(5)
            make.trailing.equalTo(containerView).offset(-5)
            make.size.equalTo(20)
        }
        
        imageViews.append(containerView)
    }
    
    @objc private func removeImageView(_ sender: UIButton) {
        let index = sender.tag
        removeImageAtIndex?(index)
    }
    
    private func setupPhotoScrollView() {
        photoScrollView.subviews.forEach { $0.removeFromSuperview() }
        
        let stackView = UIStackView(arrangedSubviews: [photoButton] + imageViews)
        stackView.axis = .horizontal
        stackView.spacing = 10
        
        photoScrollView.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(photoScrollView)
            make.height.equalTo(80)
        }
        
        let totalWidth = CGFloat(imageViews.count * 80) + CGFloat((imageViews.count + 1) * 10) + 20
        photoScrollView.contentSize = CGSize(width: totalWidth, height: 80)
        
        photoButton.isEnabled = imageViews.count < 5
    }
    
    private func updatePhotoCount() {
        photoCountLabel.text = "\(imageViews.count)/5"
    }
    
    var removeImageAtIndex: ((Int) -> Void)?
    
    func updateButtonSelection(selectedIndex: Int) {
        wodButton.backgroundColor = .white
        wodButton.setTitleColor(.black, for: .normal)
        feedbackButton.backgroundColor = .white
        feedbackButton.setTitleColor(.black, for: .normal)
        communicationButton.backgroundColor = .white
        communicationButton.setTitleColor(.black, for: .normal)
        
        switch selectedIndex {
        case 0:
            wodButton.backgroundColor = .myAppMain
            wodButton.setTitleColor(.white, for: .normal)
            setPhotoSelectionVisible(true)
        case 1:
            feedbackButton.backgroundColor = .myAppMain
            feedbackButton.setTitleColor(.white, for: .normal)
            setPhotoSelectionVisible(true)
        case 2:
            communicationButton.backgroundColor = .myAppMain
            communicationButton.setTitleColor(.white, for: .normal)
            setPhotoSelectionVisible(false)
        default:
            break
        }
    }
}
