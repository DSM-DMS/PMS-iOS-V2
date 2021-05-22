//
//  PMSStepsTests.swift
//  PMS-iOS-V2UITests
//
//  Created by GoEun Jeong on 2021/05/20.
//

import Foundation
import XCTest

class PMSStepsUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        app = XCUIApplication()
        app.launchArguments = ["testing"]
        app.launch()
    }
    
    func test_app_lunched_PMS() {
        login()
        XCTAssertTrue(app.navigationBars["PMS"].exists)
    }
    
    func test_go_LoginView() {
        login()
        app.buttons["로그인"].tap()
        XCTAssertTrue(app.navigationBars["로그인"].exists)
        app.navigationBars.buttons.element(boundBy: 0).tap()
    }
    
    func test_go_RegisterView() {
        login()
        app.buttons["회원가입"].tap()
        XCTAssertTrue(app.navigationBars["회원가입"].exists)
        app.navigationBars.buttons.element(boundBy: 0).tap()
    }
    
    func login() {
        if app.buttons["공지"].exists {
            app.navigationBars.buttons.element(boundBy: 0).tap()
        }
    }
}
