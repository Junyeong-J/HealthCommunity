//
//  RoutineData.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/21/24.
//

import Foundation

struct Routine {
    let name: String
    let routineImageName: String
    var isSelected: Bool = false
    
    mutating func select() {
        isSelected = true
    }
}

struct RoutineData {
    
    static let categories = [
        "하체", "가슴", "등", "어깨", "팔", "역도", "복근", "기타", "유산소"
    ]
    
    static func createRoutines(from names: [String], routineImageName: String) -> [Routine] {
        return names.map { Routine(name: $0, routineImageName: routineImageName) }
    }
    
    private static let legsRoutineNames = [
        "바벨 백스쿼트",
        "프론트 스쿼드",
        "덤벨 스플릿 스쿼트",
        "에어 스쿼트",
        "컨벤셔널 데드리프트",
        "레그 프레스",
        "레그 익스텐션",
        "런지",
        "브이 스쿼트",
        "리버스 브이 스쿼트",
        "힙 어브덕션 머신",
        "트랩바 데드리프트"
    ]
    
    private static let chestRoutineNames = [
        "벤치프레스",
        "인클라인 벤치프레스",
        "덤벨 벤치프레스",
        "딥스",
        "푸시업",
        "인클라인 체스트 프레스 머신",
        "로우 풀리 케이블 플라이"
    ]
    
    private static let backRoutineNames = [
        "풀업",
        "바벨 로우",
        "펜들레이 로우",
        "원암 덤벨 로우",
        "시티드 로우 머신",
        "랫풀다운",
        "하이퍼 익스텐션",
        "케이블 암 풀다운",
        "어시스트 풀업 머신"
    ]
    
    private static let shouldersRoutineNames = [
        "오버헤드 프레스",
        "덤벨 숄더 프레스",
        "아놀드 덤벨 프레스",
        "덤벨 레터럴 레이즈",
        "벤트오버 덤벨 레터럴 레이즈",
        "덤벨 슈러그",
        "리어 델토이드 플라이 머신",
        "원암 케이블 레터럴 레이즈"
    ]
    
    private static let armsRoutineNames = [
        "바벨 컬",
        "이지바 컬",
        "덤벨 컬",
        "케이블 컬",
        "케이블 트라이셉 익스텐션",
        "덤벨 킥백",
        "케이블 푸시다운",
        "바벨 프리쳐 컬",
        "인클라인 덤벨 컬",
        "벤치 딥스"
    ]
    
    private static let weightliftingRoutineNames = [
        "클린",
        "클린&저크",
        "저크",
        "케이블 크런치",
        "클린 하이풀",
        "스내치 하이풀"
    ]
    
    private static let absRoutineNames = [
        "싯업",
        "브이 업",
        "크런치",
        "힐 터치",
        "레그레이즈",
        "행잉 레그 레이즈",
        "러시안 트위스트",
        "플랭크",
        "사이드 크런치"
    ]
    
    private static let othersRoutineNames = [
        "버피",
        "박스 점프",
        "바 머슬업",
        "링 머슬업",
        "배틀링 로프",
        "터키쉬 겟업"
    ]
    
    private static let cardioRoutineNames = [
        "걷기",
        "달리기",
        "줄넘기",
        "계단오르기"
    ]
    
    static let legsRoutines = createRoutines(from: legsRoutineNames, routineImageName: "figure.strengthtraining.functional")
    static let chestRoutines = createRoutines(from: chestRoutineNames, routineImageName: "figure.mixed.cardio")
    static let backRoutines = createRoutines(from: backRoutineNames, routineImageName: "figure.rower")
    static let shouldersRoutines = createRoutines(from: shouldersRoutineNames, routineImageName: "figure.play")
    static let armsRoutines = createRoutines(from: armsRoutineNames, routineImageName: "dumbbell")
    static let weightliftingRoutines = createRoutines(from: weightliftingRoutineNames, routineImageName: "figure.strengthtraining.traditional")
    static let absRoutines = createRoutines(from: absRoutineNames, routineImageName: "figure.core.training")
    static let othersRoutines = createRoutines(from: othersRoutineNames, routineImageName: "figure.cooldown")
    static let cardioRoutines = createRoutines(from: cardioRoutineNames, routineImageName: "figure.highintensity.intervaltraining")
    
}

