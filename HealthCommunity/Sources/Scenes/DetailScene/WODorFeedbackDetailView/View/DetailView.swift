//
//  DetailView.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/25/24.
//

import UIKit
import SnapKit
import Kingfisher

final class DetailView: BaseView {
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    private let profileImageView = OpponentProfileImage()
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = Font.bold16
        label.textColor = .myAppBlack
        return label
    }()
    
    private let mainImageView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private let postContentLabel: UILabel = {
        let label = UILabel()
        label.font = Font.regular14
        label.textColor = .darkGray
        label.numberOfLines = 0
        return label
    }()
    
    let routineToggleView = ToggleDetailView(
        title: "루틴",
        viewText: "루틴 자세히보기",
        hideText: "루틴 숨기기",
        actionButtonText: "내 루틴에 저장",
        actionButtonImage: UIImage(systemName: "heart")
    )
    
    let nutrientsToggleView = ToggleDetailView(
        title: "오늘 활동량",
        viewText: "오늘 활동량 자세히보기",
        hideText: "오늘 활동량 숨기기"
    )
    
    let exerciseTimeToggleView = ToggleDetailView(
        title: "운동시간",
        viewText: "운동시간 자세히보기",
        hideText: "운동시간 숨기기"
    )
    
    let calorieToggleView = ToggleDetailView(
        title: "칼로리",
        viewText: "칼로리 자세히보기",
        hideText: "칼로리 숨기기"
    )
    
    let showCommentsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("댓글 보기", for: .normal)
        button.setTitleColor(.myAppMain, for: .normal)
        button.titleLabel?.font = Font.bold16
        return button
    }()
    
    override func configureHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        [ profileImageView, nicknameLabel, mainImageView,
          postContentLabel, routineToggleView, nutrientsToggleView,
          exerciseTimeToggleView, calorieToggleView, showCommentsButton ].forEach { contentView.addSubview($0) }
    }
    
    override func configureLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.width.equalTo(scrollView.snp.width)
            make.edges.equalTo(scrollView)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.leading.equalTo(contentView).inset(16)
            make.size.equalTo(40)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageView)
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
        }
        
        mainImageView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(contentView)
            make.height.equalTo(300)
        }
        
        postContentLabel.snp.makeConstraints { make in
            make.top.equalTo(mainImageView.snp.bottom).offset(16)
            make.leading.trailing.equalTo(contentView).inset(16)
        }
        
        routineToggleView.snp.makeConstraints { make in
            make.top.equalTo(postContentLabel.snp.bottom).offset(16)
            make.leading.trailing.equalTo(contentView).inset(16)
        }
        
        nutrientsToggleView.snp.makeConstraints { make in
            make.top.equalTo(routineToggleView.snp.bottom).offset(16)
            make.leading.trailing.equalTo(contentView).inset(16)
        }
        
        exerciseTimeToggleView.snp.makeConstraints { make in
            make.top.equalTo(nutrientsToggleView.snp.bottom).offset(16)
            make.leading.trailing.equalTo(contentView).inset(16)
        }
        
        calorieToggleView.snp.makeConstraints { make in
            make.top.equalTo(exerciseTimeToggleView.snp.bottom).offset(16)
            make.leading.trailing.equalTo(contentView).inset(16)
        }
        
        showCommentsButton.snp.makeConstraints { make in
            make.top.equalTo(calorieToggleView.snp.bottom).offset(16)
            make.leading.trailing.equalTo(contentView).inset(16)
            make.bottom.equalTo(contentView).inset(16)
            make.height.equalTo(50)
        }
    }
    
    func configureData(data: [Post]) {
        guard let data = data.first else { return }
        
        if let profileImageUrl = URL(string: APIURL.baseURL + (data.creator.profileImage ?? "")) {
            profileImageView.kf.setImage(with: profileImageUrl)
        } else {
            profileImageView.image = UIImage(systemName: "star.fill")
        }
        
        nicknameLabel.text = data.creator.nick
        postContentLabel.text = data.content2
        mainImageView.subviews.forEach { $0.removeFromSuperview() }
        
        let imageUrls = data.files.compactMap { URL(string: APIURL.baseURL + $0) }
        
        if imageUrls.isEmpty {
            mainImageView.isHidden = true
            mainImageView.snp.updateConstraints { make in
                make.height.equalTo(0)
            }
        } else {
            mainImageView.isHidden = false
            mainImageView.snp.updateConstraints { make in
                make.height.equalTo(300)
            }
            
            var previousImageView: UIImageView?
            for (index, imageUrl) in imageUrls.enumerated() {
                let imageView = UIImageView()
                imageView.contentMode = .scaleAspectFill
                imageView.clipsToBounds = true
                imageView.kf.setImage(with: imageUrl)
                mainImageView.addSubview(imageView)
                
                imageView.snp.makeConstraints { make in
                    make.top.bottom.equalTo(mainImageView)
                    make.width.equalTo(mainImageView)
                    make.height.equalTo(300)
                    
                    if let previous = previousImageView {
                        make.leading.equalTo(previous.snp.trailing)
                    } else {
                        make.leading.equalTo(mainImageView)
                    }
                    
                    if index == imageUrls.count - 1 {
                        make.trailing.equalTo(mainImageView)
                    }
                }
                
                previousImageView = imageView
            }
        }
        
        if data.productID == "소통" {
            routineToggleView.isHidden = true
            nutrientsToggleView.isHidden = true
            exerciseTimeToggleView.isHidden = true
            calorieToggleView.isHidden = true
        } else {
            routineToggleView.isHidden = false
            nutrientsToggleView.isHidden = false
            exerciseTimeToggleView.isHidden = false
            calorieToggleView.isHidden = false
            
            let routines = parseRoutineData(data.content ?? "")
            routineToggleView.setContentText(routines.map { routine in
                """
                \(routine.category) | \(routine.name)
                - \(routine.sets)세트 \(routine.weight)KG, \(routine.reps)회
                """
            }.joined(separator: "\n\n"))
            
            let activityData = parseActivityData(data.content1 ?? "")
            nutrientsToggleView.setContentText(activityData)
            
            exerciseTimeToggleView.setContentText(data.content3)
            calorieToggleView.setContentText(data.content4)
        }
    }


    func parseRoutineData(_ data: String) -> [RoutinDetail] {
        var routines = [RoutinDetail]()
        
        //세미콜론을 기준 루틴으로 분리
        let exercises = data.components(separatedBy: "; ")
    
        for exercise in exercises {
            let details = exercise.components(separatedBy: ", ")//, 로 분리
            if details.count == 4 {//요소가 무조건 4개
                let categoryAndName = details[0].components(separatedBy: "|")//카테고리 이름 구분
                let category = categoryAndName[0].trimmingCharacters(in: .whitespacesAndNewlines)//공백 앞뒤로 제거
                let name = categoryAndName[1].trimmingCharacters(in: .whitespacesAndNewlines)//공백 앞뒤로 제거
                let sets = details[1]//세트
                let weight = details[2]//중량
                let reps = details[3]//1회당 횟수
                //RoutinDetail 객체로 구조화하여 배열에 추가
                let routine = RoutinDetail(category: category, name: name, sets: sets, weight: weight, reps: reps)
                routines.append(routine)
            }
        }
        return routines
    }

    func parseActivityData(_ data: String) -> String {
        let components = data.components(separatedBy: ", ")
        guard components.count == 4 else {
            return "데이터가 없습니다."
        }
        let steps = components[0]
        let distance = components[1]
        let calories = components[2]
        let standingTime = components[3]
        return "오늘 활동량 : \(steps)걸음, \(distance)km 이동, \(calories)kcal 활동량 소비, \(standingTime)분 서있기"
    }

}

