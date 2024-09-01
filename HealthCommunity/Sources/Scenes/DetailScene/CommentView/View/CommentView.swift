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
    
    let commentTextField = BoxTypeTextField(style: .comment)
    
    let sendButton = SendButton(title: .send)
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CommentTableViewCell.self, forCellReuseIdentifier: CommentTableViewCell.identifier)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    override func configureHierarchy() {
        [tableView, commentInputView].forEach { addSubview($0) }
        [commentTextField, sendButton].forEach { commentInputView.addSubview($0) }
    }
    
    override func configureLayout() {
        commentInputView.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).inset(8)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }
        
        commentTextField.snp.makeConstraints { make in
            make.leading.verticalEdges.equalToSuperview()
            make.trailing.equalTo(sendButton.snp.leading).offset(-8)
        }
        
        sendButton.snp.makeConstraints { make in
            make.trailing.verticalEdges.equalToSuperview()
            make.width.equalTo(60)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(20)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(commentInputView.snp.top).offset(-8)
        }
    }
    
}

extension CommentView: NaviProtocol {
    var navigationTitle: String {
        return NavigationTitle.comment.title
    }
}
