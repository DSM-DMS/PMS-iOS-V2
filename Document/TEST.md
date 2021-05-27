# TDD

TDD를 위한 테스트 스펙입니다. 기능별로 테스트해야 할 목록을 작성한 후, ViewModel과 View를 Unit Test 및 UI Test합니다.



### 목차

1. [Auth](#Auth)
2. [Calendar](#Calendar)
3. [Meal](#Meal)
4. [Notice](#Notice)
5. [Introduce](#Introduce)
6. [Mypage](#Mypage)



## Auth

#### 1. PMSView

PMSViewModelTests

- [x] 로그인 & 회원가입 버튼 클릭 시 steps에 잘 들어가는지.

PMSStepsUITests 

- [x] 로그인 & 회원가입 버튼 클릭 시 네비게이션이 잘 되는지.

#### 2. Login

Unit Test

- LoginViewModelTests

- [x] 이메일 형식이 지켜지지 않았을 시 로그인 버튼이 비활성화
- [x] 이메일 혹은 비밀번호가 입력되지 않았을 시 로그인 버튼이 비활성화
- [x] 비밀번호 입력 시 EyeImage 등장
- [x] 존재하지 않는 계정으로 로그인 시 Alert가 잘 띄워지는지.
- [x] 네트워크가 없을 시 Alert가 잘 띄워지는지.
- [x] 테스트 계정으로 로그인 시 SuccessLottieView가 잘 띄워지는지.

- LoginViewTests

- [x] 이메일이 입력중일 시 emailLine 색상 변경
- [x] 패스워드 입력중일 시 passwordLine 색상 변경
- [x] 비밀번호에 한글자 이상 입력 시 eyeImage isHidden 변경
- [x] 로그인 버튼이 비활성화일 시 버튼 alpha 변경
- [x] 로딩중일 시 activityIndicator isAnimating

UI Test

- [x] 존재하지 않는 계정으로 로그인 시 Alert가 잘 띄워지는지.
- [x] 존재하는 계정으로 로그인 시 SuccessLottieView가 잘 띄워지는지.



#### 3. Register

Unit Test

- RegisterViewModelTests

- [x] 이메일 형식이 지켜지지 않았을 시 회원가입 버튼이 비활성화
- [x] 비밀번호 두 개가 서로 맞지 않을 때 회원가입 버튼 비활성화, ErrorMessage 활성화
- [x] 이메일 혹은 비밀번호가 입력되지 않았을 시 회원가입 버튼이 비활성화
- [x] 비밀번호 입력 시 EyeImage 등장
- [x] 이미 존재하는 이메일로 회원가입 시 Alert가 잘 띄워지는지.
- [x] 네트워크가 없을 시 Alert가 잘 띄워지는지.
- [x] 테스트 계정으로 회원가입 시 SuccessLottieView가 잘 띄워지는지.

- RegisterViewTests

- [x] 닉네임이 입력중일 시 nameLine 색상 변경
- [x] 이메일이 입력중일 시 emailLine 색상 변경
- [x] 패스워드 입력중일 시 passwordLine 색상 변경
- [x] 패스워드 재입력중일 시 repasswordLine 색상 변경
- [x] 회원가입 버튼이 비활성화일 시 버튼 alpha 변경
- [x] 로딩중일 시 activityIndicator isAnimating



## Calendar

Unit Test

- CalendarViewModelTests
- [x] ViewDidLoad 시 캘린더를 잘 가지고 오는지
- [x] ViewDidLoad 시 Activity Indicator is Animating
- [x] 날짜를 클릭하면 그 날짜에 맞는 일정을 갖고 오는지
- [x] 선택된 날짜에 일정이 없다면 일정이 없다고 표시하는지
- [x] Month를 바꾸면 그 달에 맞는 일정을 가지고 오는지.
- [x] 네트워크가 없을 시 Alert가 잘 띄워지는지.

UI Test

- [x] ViewDidLoad 시 '날짜를 클릭하시면 일정을 볼 수 있습니다.' 문구가 있는지.



## Meal

Unit Test

- [x] ViewDidLoad 시 Activity Indicator is Animating
- [x] ViewDidLoad 시 급식을 잘 가지고 오는지
- [x] 다음 날로 넘기면 오늘 날짜 + 1 day로 뜨는지.



## Notice

Unit Test

- NoticeViewModelTests

- [x] ViewDidLoad 시 Activity Indicator is Animating
- [x] ViewDidLoad 시 공지사항 잘 가지고 오는지
- [ ] 페이지 넘기면 다음 공지사항 잘 가지고 오는지 // 백엔드가 아직 page 기능이 안나옴
- [x] 페이지가 1일 때 이전 버튼 눌러도 변화사항이 없는지.
- [x] 다음 버튼을 누르면 페이지가 잘 + 되는지
- NoticeDetailViewModelTests
- [x] ViewDidLoad 시 Activity Indicator is Animating
- [x] ViewDidLoad 시 세부 공지사항 잘 가지고 오는지
- [x] 네트워크가 없을 시 Alert가 잘 띄워지는지.
- [ ] 댓글 작성 // 백엔드가 나오면



## Introduce

Unit Test

- ClubViewModelTests

- [ ] ViewDidLoad 시 동아리 리스트 잘 가지고 오는지
- [ ] ViewDidLoad 시 Activity Indicator is Animating
- [ ] 네트워크가 없을 시 Alert가 잘 띄워지는지.

- DetailClubViewModelTests

- [ ] ViewDidLoad 시 동아리 잘 가지고 오는지
- [ ] ViewDidLoad 시 Activity Indicator is Animating
- [ ] 네트워크가 없을 시 Alert가 잘 띄워지는지.



- CompanyViewModelTests

  // 백엔드 개발 아직 안됨

- [ ] ViewDidLoad 시 회사 리스트 잘 가지고 오는지

- [ ] ViewDidLoad 시 Activity Indicator is Animating

- [ ] 네트워크가 없을 시 Alert가 잘 띄워지는지.



- DeveloperViewModelTests
- [ ] ViewDidLoad 시 개발자 리스트 잘 가지고 오는지
- [ ] ViewDidLoad 시 Activity Indicator is Animating
- [ ] 네트워크가 없을 시 Alert가 잘 띄워지는지.

## Mypage

