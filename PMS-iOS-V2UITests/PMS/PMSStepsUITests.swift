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
        let app = XCUIApplication()
        app.launch()
        XCTAssertTrue(app.buttons["로그인"].exists)
    }
}
