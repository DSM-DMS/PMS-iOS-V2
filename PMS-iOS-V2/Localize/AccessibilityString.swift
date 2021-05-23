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
    
    // ERROR
    case noInternetErrorMsg
    case notFoundUserErrorMsg
    case unknownErrorMsg
    case existUserErrorMsg
}

extension AccessibilityString {
    var localized: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}
