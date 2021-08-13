# File Structure

크게 어플리케이션, 도메인, 프레젠테이션, 데이터로 나누어 역할을 분리했습니다.

- Application

| filename                 | description                                                  |
| ------------------------ | ------------------------------------------------------------ |
| AppDelegate.swift        | RxFlow로 플로우를 관리, Firebase 설정, OAuth 설정            |
| Container+Register.swift | Container에 SwinjectAutoregistration을 사용해 ViewModel, VC, Repository 생성 |

- Extension

| filename               | description                                                  |
| ---------------------- | ------------------------------------------------------------ |
| Assets+Generated.swift | SwiftGen으로 생성된 Assets.xcassets의 swift 파일             |
| Colors+Generated.swift | SwiftGen으로 생성된 Colors.xcassets의 swift 파일. 다크모드를 지원하기 위한 컬러 |

- Localize

| filename                  | description                                          |
| ------------------------- | ---------------------------------------------------- |
| AccessibilityString.swift | 좀 더 이해하기 쉬운 AccessbilityString을 위한 열거형 |
| LocalizedString.swift     | LocalizedString을 제공하는 열겨형                    |
| Localizable.strings       | 한국어 & 영어                                        |

-  Data
   - Repository

| filename                    | description                                                  |
| --------------------------- | ------------------------------------------------------------ |
| RxMoya+TokenRefresh.swift   | 토큰이 만료되었을 때 재발급하는 retryWithAuthIfNeeded() 함수. |
| Default -- Repository.swift | --Repository 프로토콜을 상속하는 클래스. 네트워킹을 담당함.  |

​	- Manager

| filename             | description                                                  |
| -------------------- | ------------------------------------------------------------ |
| StorageManager.swift | 키체인에 token, email, password를 CRUD하는 클래스.           |
| UDManager.swift      | 현재 선택한 학생을 저장하고 있는 UserDefaults를 프로퍼티로 가짐. |

- Domain

  - Entity

  asdf

  - Manager

| filename               | description                                                  |
| ---------------------- | ------------------------------------------------------------ |
| AnalyticsManager.swift | FirebaseAnalytics의 log를 열거형으로 가지고 있고, 함수로 log를 기록하는 클래스. |
| Logger.swift           | Error, Info, Debug, Warning을 날짜, 파일이름, 함수와 같이 출력하는 클래스. |

- Presentation

| filename                 | description |
| ------------------------ | ----------- |
| AppDelegate.swift        |             |
| Container+Register.swift |             |

- Resource

| filename                       | description                           |
| ------------------------------ | ------------------------------------- |
| Assets.xcassets                | 이미지 파일들                         |
| Colors.xcassets                | -                                     |
| GoogleService-Info.plist       | 파이어베이스 설정 파일                |
| Info.plist                     | 프로젝트 설정 파일                    |
| KakaoOpenSDK-Bridging-Header.h | KakaoOpenSDK (objc)의 Bridging header |
| LaunchScreen.storyboard        | -                                     |
| PMS-iOS-V2.entitlements        | 푸시 알림, 애플로 로그인 capability   |



