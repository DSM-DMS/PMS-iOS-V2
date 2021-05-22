//
//  LoginStepsUITests.swift
//  PMS-iOS-V2UITests
//
//  Created by GoEun Jeong on 2021/05/20.
//

import Foundation
import XCTest

class LoginViewUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        app = XCUIApplication()
        app.launchArguments = ["testing"]
        app.launch()
    }
    
    func test_login_success() {
        login()
        if !isMainScreen() {
            let email = app.textFields["이메일을 입력해주세요."]
            email.tap()
            email.typeText("test@test.com")
            let password = app.secureTextFields["비밀번호를 입력해주세요."]
            password.tap()
            password.typeText("testpass")
            app.buttons["로그인"].tap()
            sleep(2)
            XCTAssertTrue(app.staticTexts["로그인에 성공하셨습니다."].exists)
        }
    }
    
    func test_login_failed() {
        login()
        if !isMainScreen() {
            let email = app.textFields["이메일을 입력해주세요."]
            email.tap()
            email.typeText("@.")
            let password = app.secureTextFields["비밀번호를 입력해주세요."]
            password.tap()
            password.typeText("failed")
            app.buttons["로그인"].tap()
            sleep(3)
            XCTAssertEqual(app.alerts.count, 1)
        }
        
    }
    
    func login() {
        if app.buttons["공지"].exists {
            app.navigationBars.buttons.element(boundBy: 0).tap()
        }
        if app.navigationBars["PMS"].exists {
            app.buttons["로그인"].tap()
        }
    }
    
    func isMainScreen() -> Bool {
        if app.buttons["공지"].exists {
            return true
        } else {
            return false
        }
    }
}
