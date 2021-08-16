# File Structure

크게 어플리케이션, 도메인, 프레젠테이션, 데이터로 나누어 역할을 분리했습니다.

목차

1. Application
2. Data
3. Domain
4. Presentation
5. Extension
6. Localize
7. Resource

----

## 1. Application

| filename                 | description                                                  |
| ------------------------ | ------------------------------------------------------------ |
| AppDelegate.swift        | RxFlow로 플로우를 관리, Firebase 설정, OAuth 설정            |
| Container+Register.swift | Container에 SwinjectAutoregistration을 사용해 ViewModel, VC, Repository 생성 |

## 2. Data

- Repository

| filename                    | description                                                  |
| --------------------------- | ------------------------------------------------------------ |
| RxMoya+TokenRefresh.swift   | 토큰이 만료되었을 때 재발급하는 retryWithAuthIfNeeded() 함수 |
| Default -- Repository.swift | --Repository 프로토콜을 상속하는 클래스. 네트워킹을 담당함   |

​	- Manager

| filename             | description                                                  |
| -------------------- | ------------------------------------------------------------ |
| StorageManager.swift | 키체인에 token, email, password를 CRUD하는 클래스            |
| UDManager.swift      | 현재 선택한 학생을 저장하고 있는 UserDefaults를 프로퍼티로 가짐 |

## 3. Domain

- Entity

- Manager

| filename               | description                                                  |
| ---------------------- | ------------------------------------------------------------ |
| AnalyticsManager.swift | FirebaseAnalytics의 log를 열거형으로 가지고 있고, 함수로 log를 기록하는 클래스 |
| Logger.swift           | Error, Info, Debug, Warning을 날짜, 파일이름, 함수와 같이 출력하는 클래스 |

​	- NetworkingInfra

| filename      | description                           |
| ------------- | ------------------------------------- |
| AuthAPI.swift | Moya를 이용해 열거형으로 관리하는 API |
| PMSAPI.swift  | -                                     |

​	- RepoInterface

| filename            | description                 |
| ------------------- | --------------------------- |
| -- Repository.swift | -- Repository 프로토콜 정의 |

## 4. Presentation

- Constraints

| filename      | description                                         |
| ------------- | --------------------------------------------------- |
| UIFrame.swift | UIScreen.main.bounds의 width와 height를 가진 구조체 |

​	- Extension

| filename                     | description                                                  |
| ---------------------------- | ------------------------------------------------------------ |
| ActivityIndicator.swift      | FirebaseAnalytics의 log를 열거형으로 가지고 있고, 함수로 log를 기록하는 클래스 |
| addSubviews.swift            | addArrangedSubview(_), addSubview(_)의 인자를 배열로 받는 extension |
| ListSection.swift            | RxDataSources header와 items를 갖고 있는 제네릭              |
| UI+LocalizedString.swift     | UIKit의 extension으로 setTitle(**_** title: LocalizedString) 등의 함수들 |
| VC+Alert.swift               | UIViewController의 extension으로 show -- Alert() 등의 함수들 |
| TextField+cancelButton.swift | UITextField의 extension으로 addDoneCancelToolbar()           |

​		- Rx

| filename              | description                    |
| --------------------- | ------------------------------ |
| Rx+Reachability.swift | reachability.rx.isDisconnected |
| Rx+UITextField.swift  | textfield.rx.shouldReturn      |
| Rx+viewDidLoad.swift  | view.rx.viewDidLoad            |

​	- Flow

| filename      | description                       |
| ------------- | --------------------------------- |
| -- Flow.siwft | RxFlow의 Flow를 상속하는 클래스들 |
| PMSStep.swift | RxFlow의 Step을 상속하는 열거형   |

​	- PMSScene

| Folder      | Files                                                        |
| ----------- | ------------------------------------------------------------ |
| PMS         | UI - OAuthButtons, PMSImages \| VC - LoginVC, RegisterVC, PMSVC \| VM - LoginVM, RegisterVM, PMSVM |
| Calendar    | CalendarTableViewCell, CalendarVC, CalendarViewModel         |
| Meal        | MealCollectionViewCell, MealVC, MealViewModel                |
| Notice      | UI - MentionButtons, NoticeDetailView, PageButtons, PreviewButton, CommentTableViewCell, MentionTableViewCell, NoticeTableViewCell |
| Introduce   | UI - ClubDetailView, ClubCollectionCell, DeveloperCollectionCell, IntroduceRow |
| Mypage      | OTPTextField - OTPFieldView, OTPTextField \| UI - MypageButtons, MypageMessageView, MypageRow, OutingListTableViewCell, PointListTableViewCell, PlusPointRow, StatusView, UserStudentTableViewCell \| VC - AddStudentVC, ChangeNicknameVC, ChangePasswordVC, MypageDelegate, MypageVC, OutingListVC, PointListVC, StudentListVC \| ViewModel - AddStudentVM, ChangeNicknameVM, ChangePasswordVM, MypageVM, OutingListVM, PointListVM, StudentListVM |
| UIComponent | ArrowButtons, BlueRedButton, SuccessLottieView               |

## 5. Extension

| filename               | description                                                  |
| ---------------------- | ------------------------------------------------------------ |
| Assets+Generated.swift | SwiftGen으로 생성된 Assets.xcassets의 swift 파일             |
| Colors+Generated.swift | SwiftGen으로 생성된 Colors.xcassets의 swift 파일. 다크모드를 지원하기 위한 컬러 |

## 6. Localize

| filename                  | description                                          |
| ------------------------- | ---------------------------------------------------- |
| AccessibilityString.swift | 좀 더 이해하기 쉬운 AccessbilityString을 위한 열거형 |
| LocalizedString.swift     | LocalizedString을 제공하는 열겨형                    |
| Localizable.strings       | 한국어 & 영어                                        |

## 7. Resource

| filename                       | description                           |
| ------------------------------ | ------------------------------------- |
| Assets.xcassets                | 이미지 파일들                         |
| Colors.xcassets                | -                                     |
| GoogleService-Info.plist       | 파이어베이스 설정 파일                |
| Info.plist                     | 프로젝트 설정 파일                    |
| KakaoOpenSDK-Bridging-Header.h | KakaoOpenSDK (objc)의 Bridging header |
| LaunchScreen.storyboard        | -                                     |
| PMS-iOS-V2.entitlements        | 푸시 알림, 애플로 로그인 capability   |
| success.json                   | Lottie 애니메이션의 json              |
| Stub.bundle                    | Test의 Stub json들이 있는 번들        |



