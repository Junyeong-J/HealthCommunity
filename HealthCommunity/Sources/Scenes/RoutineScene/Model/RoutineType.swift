//
//  RoutineType.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/21/24.
//

import Foundation

enum RoutineType: String, CaseIterable {
    case legs = "하체"
    case chest = "가슴"
    case back = "등"
    case shoulders = "어깨"
    case arms = "팔"
}

struct RoutineRoutineItem {
    let title: String
    var isSelected: Bool = false
}
