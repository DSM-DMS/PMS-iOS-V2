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

UITest 

- 로그인 / 회원가입 버튼 클릭 시 네비게이션이 잘 되는지.



#### 2. Login

Unit Test

- 이메일 형식이 지켜지지 않았을 시 로그인 버튼이 비활성화
- 이메일 혹은 비밀번호가 입력되지 않았을 시 로그인 버튼이 비활성화
- 존재하지 않는 계정으로 로그인 시 Alert가 잘 띄워지는지.
- 네트워크가 없을 시 Alert가 잘 띄워지는지.

UI Test

- SecureTextField가 TextField로 잘 변환되는지.
- 텍스트 입력 시 하단 색상이 바뀌는지.



#### 3. Register

Unit Test

- 이메일 형식이 지켜지지 않았을 시 회원가입 버튼 비활성화
- 비밀번호 두 개가 서로 맞지 않을 때 회원가입 버튼 비활성화, ErrorMessage 활성화
- 이메일 혹은 비밀번호가 입력되지 않았을 시 회원가입 버튼이 비활성화
- 이미 존재하는 이메일로 회원가입 시 Alert가 잘 띄워지는지.
- 네트워크가 없을 시 Alert가 잘 띄워지는지.

UI Test

- SecureTextField가 TextField로 잘 변환되는지.
- 텍스트 입력 시 하단 색상이 바뀌는지.



## Calendar

Unit Test

- 날짜를 클릭하면 JSON에서 그 글자에 맞는 일정을 갖고 오는지

UI Test

- 날짜를 클릭하지 않았을 시 '날짜를 클릭하시면 일정을 볼 수 있습니다' 문구가 있는지.



## Meal

Unit Test

- 다음 날로 넘기면 오늘 날짜 + 1 day로 뜨는지.



## Notice



## Introduce



## Mypage