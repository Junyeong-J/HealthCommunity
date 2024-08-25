//
//  CommentView.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/25/24.
//

import UIKit
import SnapKit

final class CommentView: BaseView {
    
    private let commentInputView = UIView()
    private let commentTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "댓글을 입력하세요..."
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("전송", for: .normal)
        return button
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CommentTableViewCell.self, forCellReuseIdentifier: CommentTableViewCell.identifier)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    override func configureHierarchy() {
        addSubview(tableView)
        addSubview(commentInputView)
        
        [commentTextField, sendButton].forEach { commentInputView.addSubview($0) }
    }
    
    override func configureLayout() {
        commentInputView.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).inset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }
        
        commentTextField.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.trailing.equalTo(sendButton.snp.leading).offset(-8)
        }
        
        sendButton.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview()
            make.width.equalTo(60)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(commentInputView.snp.top).offset(-8)
        }
    }
    
    func clearCommentInput() {
        commentTextField.text = ""
    }
    
    func setSendAction(target: Any?, action: Selector) {
        sendButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    func getCommentText() -> String? {
        return commentTextField.text
    }
}
