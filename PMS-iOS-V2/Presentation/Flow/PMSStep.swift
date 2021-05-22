//
//  PMSFlow.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import RxFlow

enum PMSStep: Step, Equatable {
    // Global
    case alert(String, AccessibilityString)
    case success(LocalizedString)
    
    // TabBar or PMSView
    case tabBarIsRequired
    case PMSIsRequired
    case modalPMSIsRequired
    
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
    
    // Introduce
    case introduceIsRequired
    case clubIsRequired
    case detailClubIsRequired(name: String)
    case companyIsRequired
    case detailCompanyIsRequired(name: String)
    case developerIsRequired
    
    // Mypage
    case mypageIsRequired
    case scoreListIsRequired
    case outingListIsRequired
    case changePasswordIsRequired
}
