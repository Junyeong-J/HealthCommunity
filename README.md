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

## 주요 기능
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
