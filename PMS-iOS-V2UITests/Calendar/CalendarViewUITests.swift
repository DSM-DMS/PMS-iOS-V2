//
//  CalendarViewUITests.swift
//  PMS-iOS-V2UITests
//
//  Created by GoEun Jeong on 2021/05/23.
//

import Foundation
import XCTest

class CalendarViewUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        app = XCUIApplication()
        app.launchArguments = ["testing"]
        app.launch()
    }
    
    func test_no_event_text() {
        login()
        XCTAssertTrue(app.staticTexts["날짜를 클릭하시면 일정을 볼 수 있습니다."].exists)
    }
    
    func login() {
        if !app.buttons["공지"].exists {
            if app.navigationBars["PMS"].exists {
                app.buttons["로그인"].tap()
            }
            let email = app.textFields["이메일을 입력해주세요."]
            email.tap()
            email.typeText("test@test.com")
            let password = app.secureTextFields["비밀번호를 입력해주세요."]
            password.tap()
            password.typeText("testpass")
            app.buttons["로그인"].tap()
            sleep(3)
        }
    }
}
