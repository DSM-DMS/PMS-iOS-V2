//
//  snapShotTests.swift
//  PMS-iOS-V2Tests
//
//  Created by GoEun Jeong on 2021/05/19.
//

import Foundation
import Foundation
import FBSnapshotTestCase
@testable import PMS_iOS_V2

class FBSnapshotTestCaseSwiftTest: FBSnapshotTestCase {
    
    override func setUp() {
        super.setUp()
        self.recordMode = true // 스크린샷 찍기
//        self.recordMode = false // 비교하기
    }
    
    func testExample() {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 64, height: 64))
        view.backgroundColor = UIColor.blue
        FBSnapshotVerifyView(view)
        FBSnapshotVerifyLayer(view.layer)
    }
    
}
