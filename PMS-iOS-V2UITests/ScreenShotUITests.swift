//
//  ScreenShotUITests.swift
//  PMS-iOS-V2UITests
//
//  Created by GoEun Jeong on 2021/06/05.
//

import XCTest

class ScreenShotUITests: XCTestCase {
    
    let app = XCUIApplication()
    
    override func setUp() {
        
        app.activate()
        setupSnapshot(app)
        app.launch()
    }
    
    func test_A_PMS_Main_View() {
        snapshot("0Main_View")
    }
    
    func test_CalendarView() {
        if !app.buttons["일정"].exists {
            login()
        }
        
        snapshot("1Calendar_View")
        
    }
    
    func test_MealView() {
        if !app.buttons["일정"].exists {
            login()
        }
        
        app.buttons["급식"].tap()
        snapshot("2Meal_View")
        
    }
    
    func test_NoticeView() {
        if !app.buttons["일정"].exists {
            login()
        }
        
        self.app.buttons["공지"].tap()
        snapshot("3Notice_View")
    }
    
    func test_IntroduceView() {
        if !app.buttons["일정"].exists {
            login()
        }
        
        self.app.buttons["소개"].tap()
        snapshot("4Introduce_View")
        
    }
    
    func test_MypageView() {
        if !app.buttons["일정"].exists {
            login()
        }
        
        self.app.buttons["내 정보"].tap()
        snapshot("5Mypage_View")
    }
    
    func login() {
        let email = app.textFields["이메일을 입력해주세요."]
        email.tap()
        email.typeText(Bundle.main.infoDictionary!["Auth Email"] as! String)
        let password = app.secureTextFields["비밀번호를 입력해주세요."]
        password.tap()
        password.typeText( Bundle.main.infoDictionary!["Auth Password"] as! String)
        app.buttons["로그인"].tap()
        sleep(2)
        XCTAssertTrue(app.staticTexts["로그인에 성공하셨습니다."].exists)
        sleep(8)
    }
    
}
