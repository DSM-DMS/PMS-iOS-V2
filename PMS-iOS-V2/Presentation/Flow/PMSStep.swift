//
//  PMSFlow.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import RxFlow
import UIKit

enum PMSStep: Step, Equatable {
    static func == (lhs: PMSStep, rhs: PMSStep) -> Bool {
        lhs.self == rhs.self
    }
    
    // Global
    case alert(String, AccessibilityString)
    case success(LocalizedString)
    case dismiss
    
    // TabBar or PMSView
    case tabBarIsRequired
    case PMSIsRequired
    
    // PMSView
    case loginIsRequired
    case registerIsRequired

    // Calendar
    case calendarIsRequired

    // Meal
    case mealIsRequired
    case mealPictureIsRequired(date: String)

    // Notice
    case noticeIsRequired
    case detailNoticeIsRequired(id: Int, title: String)
    
    // Introduce
    case introduceIsRequired
    case clubIsRequired
    case detailClubIsRequired(name: String)
    case companyIsRequired
    case detailCompanyIsRequired(name: String)
    case developerIsRequired
    
    // Mypage
    case mypageIsRequired
    case pointListIsRequired(number: Int)
    case outingListIsRequired(number: Int)
    case changePasswordIsRequired
    case logout
    case deleteStudent(name: String, handler: (UIAlertAction) -> Void)
    case dismissTabbar
    case presentTabbar
}
