# File structure

크게 어플리케이션, 도메인, 프레젠테이션, 데이터로 나누어 역할을 분리했습니다.

- Application

| filename                 | description |
| ------------------------ | ----------- |
| AppDelegate.swift        |             |
| Container+Register.swift | Swinject    |

- Extension

| filename               | description                                                  |
| ---------------------- | ------------------------------------------------------------ |
| Assets+Generated.swift | SwiftGen으로 생성된 Assets.xcassets의 swift 파일.            |
| Colors+Generated.swift | SwiftGen으로 생성된 Colors.xcassets의 swift 파일. 다크모드를 지원하기 위한 컬러. |

- Localize

| filename                  | description                                           |
| ------------------------- | ----------------------------------------------------- |
| AccessibilityString.swift | 좀 더 이해하기 쉬운 AccessbilityString을 위한 열거형. |
| LocalizedString.swift     | LocalizedString을 제공하는 열겨형                     |
| Localizable.strings       | 한국어, 영어를 지원.                                  |

-  Data

| filename                 | description |
| ------------------------ | ----------- |
| AppDelegate.swift        |             |
| Container+Register.swift |             |

- Domain

| filename                 | description |
| ------------------------ | ----------- |
| AppDelegate.swift        |             |
| Container+Register.swift |             |

- Presentation

| filename                 | description |
| ------------------------ | ----------- |
| AppDelegate.swift        |             |
| Container+Register.swift |             |



