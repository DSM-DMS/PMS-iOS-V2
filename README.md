# PMS: Parent's Management System  ![master](https://github.com/DSM-DMS/PMS-iOS-V2/actions/workflows/main.yml/badge.svg?branch=master)

부모님의 대덕소프트웨어마이스터고등학교 앱입니다.



## App Features

- [x] 학사일정, 급식, 공지사항 및 가정통신문, 학교 소개, 자녀에 대한 정보를 볼 수 있습니다.
- [x] 다크모드를 지원합니다.
- [x] VoiceOver를 지원합니다.
- [x] 한국어와 영어를 지원합니다.

| 학사일정 | 급식 | 공지사항 및 가정통신문 | 학교 소개 | 마이페이지 |
| :------: | :--: | :--------------------: | --------- | ---------- |
|<img src = "./fastlane/screenshots/ko-KR/iPhone 12 Pro Max-1Calendar_framed.png" width = 400> | <img src = "./fastlane/screenshots/ko-KR/iPhone 12 Pro Max-2Meal_framed.png" width = 400> | <img src = "./fastlane/screenshots/ko-KR/iPhone 12 Pro Max-3Notice_framed.png" width = 400> |<img src = "./fastlane/screenshots/ko-KR/iPhone 12 Pro Max-4Introduce_framed.png" width = 400>|<img src = "./fastlane/screenshots/ko-KR/iPhone 12 Pro Max-5Mypage_framed.png" width = 400>|





## Technologies

- [x] The Swift code for assets ([SwiftGen](https://github.com/SwiftGen/SwiftGen))
- [x] Code based UI ([SnapKit](https://github.com/SnapKit/SnapKit))
- [x] [RxSwift](https://github.com/ReactiveX/RxSwift) with MVVM
- [x] Reactive Flow Coordinator pattern ([RxFlow](https://github.com/RxSwiftCommunity/RxFlow))
- [x] Dependency injection ([Swinject](https://github.com/Swinject/Swinject))
- [x] Messaging, Analytics, Crashlytics, Performance ([Firebase](http://firebase.google.com/))
- [x] Swift style and conventions ([SwiftLint](https://github.com/realm/SwiftLint)) - [.swiftlint.yml](https://github.com/DSM-DMS/PMS-iOS-V2/blob/master/.swiftlint.yml)
- [x] CI/CD with Github Actions, Rome & Punic upload | download, Snapshot, Frameit (Fastlane) - [Fastfile](https://github.com/DSM-DMS/PMS-iOS-V2/blob/master/fastlane/Fastfile)
- [x] generating Xcode project ([XcodeGen](https://github.com/yonaskolb/XcodeGen)) - [project.yml](https://github.com/DSM-DMS/PMS-iOS-V2/blob/master/project.yml)

---

- [x] Test codes - [TEST.md](https://github.com/DSM-DMS/PMS-iOS-V2/blob/master/Document/TEST.md)
- [x] Snapshot view unit tests ([FBSnapshotTestCase](https://github.com/facebookarchive/ios-snapshot-test-case))



## Description of files

[File Structure.md](https://github.com/DSM-DMS/PMS-iOS-V2/blob/master/Document/File%20Structure.md)



## Getting Started

```shell
$ git clone https://github.com/DSM-DMS/PMS-iOS-V2
$ cd PMS-iOS-V2
$ xcodegen
```



## Requirements

- iOS 11+
- Swift 5
- Carthage



## Contribution

I'm waiting for your contribution.