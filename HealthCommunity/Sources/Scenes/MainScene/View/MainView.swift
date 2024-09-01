//
//  MainView.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/18/24.
//

import UIKit
import SnapKit

final class MainView: BaseView {
    
    let refreshControl = UIRefreshControl()
    
    let segmentControl: UISegmentedControl = {
        let segment = UISegmentedControl()
        segment.insertSegment(withTitle: "오운완", at: 0, animated: true)
        segment.insertSegment(withTitle: "피드벡", at: 1, animated: true)
        segment.insertSegment(withTitle: "소통", at: 2, animated: true)
        segment.selectedSegmentIndex = 0
        
        segment.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.gray,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], for: .normal)
        segment.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], for: .selected)
        
        segment.selectedSegmentTintColor = .clear
        segment.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        segment.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        
        segment.translatesAutoresizingMaskIntoConstraints = false
        return segment
    }()

    private let underLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    
    let wodTableView: UITableView = {
        let view = UITableView()
        view.register(MainWodTableViewCell.self, forCellReuseIdentifier: MainWodTableViewCell.identifier)
        view.rowHeight = 400
        view.separatorStyle = .none
        return view
    }()
    
    let feedbackTableView: UITableView = {
        let view = UITableView()
        view.register(MainFeedbackTableViewCell.self, forCellReuseIdentifier: MainFeedbackTableViewCell.identifier)
        view.rowHeight = 400
        view.separatorStyle = .none
        return view
    }()
    
    let communicationTableView: UITableView = {
        let view = UITableView()
        view.register(MainCommunityTableViewCell.self, forCellReuseIdentifier: MainCommunityTableViewCell.identifier)
        view.rowHeight = 180
        view.separatorStyle = .none
        return view
    }()
    
    let postButton = PostButton()
    
    override func configureHierarchy() {
        [segmentControl, underLineView, wodTableView,
         feedbackTableView, communicationTableView,
         postButton].forEach { addSubview($0) }
    }

    override func configureLayout() {
        segmentControl.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(10)
            make.height.equalTo(30)
        }
        
        underLineView.snp.makeConstraints { make in
            make.top.equalTo(segmentControl.snp.bottom).offset(2)
            make.height.equalTo(2)
            make.width.equalTo(segmentControl.snp.width).dividedBy(segmentControl.numberOfSegments)
            make.leading.equalTo(segmentControl.snp.leading)
        }
        
        wodTableView.snp.makeConstraints { make in
            make.top.equalTo(underLineView.snp.bottom).offset(10)
            make.bottom.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        
        feedbackTableView.snp.makeConstraints { make in
            make.edges.equalTo(wodTableView)
        }
        
        communicationTableView.snp.makeConstraints { make in
            make.edges.equalTo(wodTableView)
        }
        
        postButton.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(safeAreaLayoutGuide).inset(10)
            make.height.equalTo(50)
            make.width.equalTo(120)
        }
    }

    
    override func configureView() {
        wodTableView.isHidden = false
        feedbackTableView.isHidden = true
        communicationTableView.isHidden = true
    }
    
    func updateSegmentTableView(index: Int) {
        wodTableView.isHidden = index != 0
        feedbackTableView.isHidden = index != 1
        communicationTableView.isHidden = index != 2
        segmentControl.addTarget(self, action: #selector(changeUnderLinePosition), for: .valueChanged)
    }

    
    func adjustButtonShape(forScrollOffset offset: CGFloat) {
        DispatchQueue.main.async {
            let isCompact = offset > 100
            
            UIView.animate(withDuration: 0.3) {
                if isCompact {
                    self.postButton.snp.updateConstraints { make in
                        make.width.equalTo(50)
                    }
                    self.postButton.setTitle("", for: .normal)
                } else {
                    self.postButton.snp.updateConstraints { make in
                        make.width.equalTo(100)
                    }
                    self.postButton.setTitle("글쓰기", for: .normal)
                }
                self.layoutIfNeeded()
            }
        }
    }
    
    @objc
    private func changeUnderLinePosition(_ segment: UISegmentedControl) {
        let halfWidth = segment.frame.width / CGFloat(segment.numberOfSegments)
        let xPosition = halfWidth * CGFloat(segment.selectedSegmentIndex)
        
        UIView.animate(withDuration: 0.3) {
            self.underLineView.snp.updateConstraints { make in
                make.leading.equalTo(self.segmentControl.snp.leading).offset(xPosition)
            }
            self.layoutIfNeeded()
        }
    }

}
