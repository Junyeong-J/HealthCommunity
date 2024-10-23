![iOS 16.0](https://img.shields.io/badge/iOS-16.0-lightgrey?style=flat&color=181717)
[![Swift 5.10](https://img.shields.io/badge/Swift-5.10-F05138.svg?style=flat&color=F05138)](https://swift.org/download/) [![Xcode 15.3](https://img.shields.io/badge/Xcode-15.3-147EFB.svg?style=flat&color=147EFB)](https://apps.apple.com/kr/app/xcode/id497799835?mt=12)

# 웨이트하우스 - 웨하스

## 프로젝트 소개
MZ세대 감성으로 운동 기록과 사진을 공유하고, 사용자들끼리 피드백을 주고받으며, 하루 활동과 루틴을 기록하고 헬스 클래스에 참여할 수 있는 커뮤니티 앱
- 진행 기간
    - 기획 : 2024.08.13 ~ 2024.08.14
    - 개발 : 2024.08.15 ~ 2024.09.01
- 기술 스택
    - 개발 환경 
       - iOS : Swift 5.10, Xcode 15.3
       - 서버 : LSLP서버
    - 라이브러리 
       - iOS : RxSwift, FSCalendar, Alamofire, Kingfisher, SnapKit, HealthKit
    - Deployment Target : iOS 16.0

## 키워드
- HealthKit: 사용자의 건강 데이터를 가져오고, 운동 기록과 칼로리 소모량 등을 관리하는 데 사용.
- RxSwift: 비동기 데이터 흐름 관리 및 반응형 프로그래밍을 위한 라이브러리.
- 포트원 (PayPort): 헬스 클래스 결제를 위한 결제 시스템 연동.
- MVVM 패턴: 데이터와 뷰를 효율적으로 관리하기 위해 ViewModel 사용.

## 주요 기능
- 로그인: 로그인 성공 시 서버로부터 Access Token이 발급됩니다.
- 오운완 커뮤니티: 오늘 운동한 사진을 자랑하며, 자신의 운동 루틴을 커뮤니티에 공유할 수 있습니다.
- 피드백 커뮤니티: 자신이 작성한 운동 루틴이나 사진에 대해 피드백을 받을 수 있는 공간입니다. 다른 사용자들이 댓글로 피드백을 제공하며, 피드백을 기반으로 운동 계획을 수정하거나 개선할 수 있습니다.
- 소통 커뮤니티: 운동 외의 주제로 자유롭게 대화하고 정보를 공유하는 커뮤니티입니다. 일상적인 이야기부터 운동 관련 정보까지, 다양한 주제로 소통할 수 있습니다.
- 글쓰기: 사진과 운동 루틴을 포함한 글을 작성할 수 있으며, HealthKit를 사용해 사용자의 건강 데이터를 가져와 오늘 몇 걸음 걸었는지, 몇 km를 걸었는지, 몇 칼로리를 소모했는지, 몇 분 서 있었는지 등의 데이터를 함께 보여줍니다.
- 내 운동 기록 관리: 사용자가 직접 자신의 운동 루틴을 등록할 수 있습니다. 하체, 상체 운동 등을 선택하고, 세트 수, 횟수 등을 기록하여 운동 기록을 체계적으로 관리할 수 있습니다.
- 클래스 참여: 포트원(PayPort)을 통한 결제 시스템을 사용해 헬스 클래스에 참여할 수 있는 기능입니다. 사용자는 결제 후 클래스에 참여할 수 있으며, 진행되는 클래스에 대한 정보도 확인 가능합니다.
- 프로필: 사용자의 프로필을 수정할 수 있으며, 좋아요를 누른 루틴 목록을 확인할 수 있습니다.


## 프로젝트 주요 화면

| **내 루틴 기록 화면** | **루틴 좋아요 기능** | **커뮤니티 상세화면** | **클래스 참여 (포트원 결제 연동)** |
|-----------------------|-----------|-----------|-----------|
| <img src="https://github.com/user-attachments/assets/4c156c58-c1b5-472c-bb8a-bb7dc5a746b4" width="200"/> | <img src="https://github.com/user-attachments/assets/3a92f457-da9c-4dea-8557-0ed0490b8bf1" width="200"/> | <img src="https://github.com/user-attachments/assets/5e003085-f0e2-4570-9a46-3f841b7c214e" width="200"/> | <img src="https://github.com/user-attachments/assets/0c147427-e1d2-4a49-b5d4-a447042add41" width="200"/> |

## 트러블슈팅
1. HealthKit데이터 가져오기에서 반환 문제
    - 처음에 Apple에서 제공하는 쿼리문을 사용하여 HealthKit데이터를 가져오려고 했지만, 값이 아예 반환되지 않는 문제가 발생했습니다.
2. 해결과정
   - 먼저 내가 가져오려는 데이터 타입이 정확한지부터 확인했습니다. HealthKit에 해당 데이터 타입이 존재하지 않거나, 값이 0으로 반환되는 상황, 혹은 쿼리문이 실패할 가능성도 고려했습니다.
   - 쿼리문에서 날짜 범위가 잘못 설정되었을 가능성을 의심해 날짜 출력도 확인했습니다. 하지만 오류는 없었고 여전히 데이터 값이 0으로 나왔습니다.
   - 그러나 문제의 원인은 데이터가 실제로 존재하지 않아서였습니다. 예를 들어, 사용자가 지정한 날짜에 걸음 수가 없으면, 0으로 반환되고 데이터를 표시할 수 없었던 것입니다.
   ~~~swift
    private func fetchHealthData(for date: Date, type: HKQuantityTypeIdentifier, unit: HKUnit, completion: @escaping (Double) -> Void) {
        //데이터를 가져올 수 있는 타입인지 확인
        guard let quantityType = HKQuantityType.quantityType(forIdentifier: type) else {
            completion(0)//없으면 0으로 반환
            return
        }
        
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: date)//시작일
        let endDate = calendar.date(byAdding: .day, value: 1, to: startDate)!// 끝지점
        
        // 특정 날짜 설정에 대한 쿼리문
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        //누적 데이터 가져오기
        let query = HKStatisticsQuery(quantityType: quantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            if let error = error {
                print("error: \(error.localizedDescription)")
                completion(0)
                return
            }
            
            // 결과에서 합계를 추출
            guard let result = result, let sum = result.sumQuantity() else {
                completion(0)
                return
            }
            
            // 주어진 단위로 변환
            let value = sum.doubleValue(for: unit)
            DispatchQueue.main.async {
                completion(value)
            }
        }
        healthStore.execute(query)
    }
   ~~~
    최종적으로 이렇게 나왔습니다.
   
4. 결과
    - 데이터 타입과 단위가 HealthKit에서 올바르게 설정되었는지 확인하고, 해당하는 데이터에 대해서만 쿼리를 실행하도록 수정했습니다.
    - HealthKit에서 데이터를 반환하지 않을 때 0으로 처리하는 로직을 추가하여, 빈 값이 반환되더라도 앱이 정상적으로 동작하도록 개선했습니다.

## 회고
- UI 부족함: 사용자 경험을 고려할 때 UI 디자인이 다소 단순하게 느껴졌고, 좀 더 직관적이고 세련된 인터페이스를 제공할 수 있었을 것 같다는 아쉬움이 남습니다.
- HealthKit 활용도의 아쉬움: HealthKit 데이터를 활용하여 사용자의 운동 기록을 시각화하는 부분에서 좀 더 다양한 차트와 그래프를 제공했으면 좋았을 것 같다는 아쉬움이 남습니다.
  다양한 차트를 구현했다면 사용자에게 목표 달성 현황을 직관적으로 제공하고, 더 큰 동기 부여를 할 수 있었을 것입니다. 이 부분은 차후 프로젝트에서 꼭 반영하고 싶습니다.


