//
//  AccessibilityString.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/20.
//

import Foundation

public enum AccessibilityString: String, Equatable, Hashable {
    // Navigation Title
    case PMSView
    case loginView
    case registerView
    case calendarTitle
    case mealTitle
    case noticeTitle
    case introduceTitle
    
    // Login
    case facebookLogin
    case naverLogin
    case kakaotalkLogin
    case appleLogin
    
    // Register
    case facebookRegister
    case naverRegister
    case kakaotalkRegister
    case appleRegister
    
    // Button
    case loginButton
    case registerButton
    case noLoginButton
    case showPasswordButton
    case leftArrowButton
    case rightArrowButton
    case flipMeal
    case previousPageButton
    case nextPageButton
    case modifyNickname
    case viewStudents
    case addStudent
    case toOutingListButton
    case toChangePasswordButton
    case toLogoutButton
    
    // ERROR
    case noInternetErrorMsg
    case notFoundUserErrorMsg
    case unknownErrorMsg
    case existUserErrorMsg
    case notMatchPasswordErrorMsg
    case notMatchCurrentPasswordErrorMsg
    case notMatchStudentErrorMsg
    
    // Placeholder
    case noStudentPlaceholder
    case noAuthPlaceholder
    case noOutingPlaceholder
    case noPointListPlaceholder
    case noNoticeListPlaceholder
}

extension AccessibilityString {
    public var localized: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}
