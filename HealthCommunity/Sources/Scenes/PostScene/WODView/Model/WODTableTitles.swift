//
//  WODTableTitles.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/20/24.
//

import Foundation

enum WODTableTitles: String {
    case routine = "루틴 추가"
    case nutrient = "영양소"
    case workoutTime = "운동 시간"
    case calory = "칼로리"
    
    static var allTitles: [String] {
        return [routine.rawValue, nutrient.rawValue, workoutTime.rawValue, calory.rawValue]
    }
}
