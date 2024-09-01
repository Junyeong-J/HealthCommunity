//
//  NavigationTitle.swift
//  HealthCommunity
//
//  Created by 전준영 on 9/1/24.
//

import Foundation

enum NavigationTitle {
    case main
    case comment
    case myToutine
    case myHealthKitData
    case myRoutineSelete
    case healthClass
    case profile
    case editProfile
    case likeRoutine
    
    var title: String {
        switch self {
        case .main:
            return "웨이트 하우스"
        case .comment:
            return "댓글"
        case .myToutine:
            return "내 루틴 기록하기"
        case .myHealthKitData:
            return "내 오늘 건강 데이터 가져오기"
        case .myRoutineSelete:
            return "내 루틴 선택"
        case .healthClass:
            return "헬스 클럽 클래스"
        case .profile:
            return "내 프로필"
        case .editProfile:
            return "프로필 수정"
        case .likeRoutine:
            return "루틴 좋아요 목록"
        }
    }
}
