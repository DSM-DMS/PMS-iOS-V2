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
- [x] 로그인없이 시작 버튼 클릭 시 steps에 잘 들어가는지.

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

- IntroduceViewModelTests
- [x] 동아리 소개 버튼 클릭 시 steps에 잘 들어가는지
- [x] 취업처 소개 버튼 클릭 시 steps에 잘 들어가는지
- [x] 개발자 소개 버튼 클릭 시 steps에 잘 들어가는지

- ClubViewModelTests

- [x] ViewDidLoad 시 동아리 리스트 잘 가지고 오는지
- [x] ViewDidLoad 시 Activity Indicator is Animating
- [x] 네트워크가 없을 시 Alert가 잘 띄워지는지.
- [x] 사진 url을 한글로 인코딩을 잘 하는지
- [x] 동아리 클릭시 steps에 잘 들어가는지

- DetailClubViewModelTests

- [x] ViewDidLoad 시 동아리 잘 가지고 오는지
- [x] ViewDidLoad 시 Activity Indicator is Animating
- [x] 네트워크가 없을 시 Alert가 잘 띄워지는지.
- [x] 사진 url을 한글로 인코딩을 잘 하는지



- CompanyViewModelTests

  // 백엔드 개발 아직 안됨

- [ ] ViewDidLoad 시 회사 리스트 잘 가지고 오는지

- [ ] ViewDidLoad 시 Activity Indicator is Animating

- [ ] 네트워크가 없을 시 Alert가 잘 띄워지는지.

- [ ] 사진 url을 한글로 인코딩을 잘 하는지



- DeveloperViewModelTests
- [x] ViewDidLoad 시 개발자 리스트 잘 가지고 오는지

## Mypage

- MypageViewModelTests
- [x] ViewDidLoad 시 유저 정보 잘 가지고 오는지
- [x] ViewDidLoad 시 학생 정보 잘 가지고 오는지
- [x] ViewDidLoad 시 Activity Indicator is Animating
- [ ] 학생 바꿨을 때 그 학생 정보 잘 가져오는지 // Massive VC...
- [x] 로그아웃 버튼 클릭 시 alert가 steps에 잘 들어가는지
- [x] 비밀번호 변경 버튼 클릭 시 steps에 잘 들어가는지
- [x] 외출 내역 보기 버튼 클릭 시 steps에 잘 들어가는지
- [x] 상벌점 클릭 시 steps에 잘 들어가는지
- [x] 학생 리스트 및 닉네임 변경 클릭 시 tabbar가 사라지는지
- [x] 검은 배경 클릭 시 tabbar가 나타나는지
- [ ] 닉네임 클릭 시 닉네임 변경 뷰의 isHidden이 바뀌는지 // Massive VC...
- [ ] 학생 클릭 시 학생 리스트 뷰의 isHidden이 바뀌는지 // Massive VC...
- [x] 로그인하지 않았을 때 로그인이 필요합니다 뷰가 뜨는지
- ChangePasswordViewModelTests
- [x] 비밀번호 두 개가 서로 맞지 않을 때 회원가입 버튼 비활성화, ErrorMessage 활성화
- [x] 현재 비밀번호 입력x 또는 비밀번호가 맞지 않았을 시 변경 버튼이 비활성화
- [x] 비밀번호 입력 시 EyeImage 등장
- [x] 현재 비밀번호가 맞지 않을 시 시 Alert가 잘 띄워지는지.
- [x] 네트워크가 없을 시 Alert가 잘 띄워지는지.
- [x] 테스트 계정으로 회원가입 시 SuccessLottieView가 잘 띄워지는지.
- ChangePasswordViewTests
- [x] 현재 비밀번호 입력중일 시 nowPasswordLine 색상 변경
- [x] 바꿀 비밀번호 입력중일 시 newPasswordLine 색상 변경
- [x] 바꿀 비밀번호 재입력중일 시 reNewPasswordLine 색상 변경
- [x] 변경 버튼이 비활성화일 시 버튼 alpha 변경
- [x] 로딩중일 시 activityIndicator isAnimating
- PointListViewModelTests
- [x] ViewDidLoad 시 Activity Indicator is Animating
- [x] ViewDidLoad 시 상벌점 내역 잘 가지고 오는지
- [x] 네트워크가 없을 시 Alert가 잘 띄워지는지.
- OutingListViewModelTests
- [x] ViewDidLoad 시 Activity Indicator is Animating
- [x] ViewDidLoad 시 외출 내역 잘 가지고 오는지
- [x] 네트워크가 없을 시 Alert가 잘 띄워지는지.
