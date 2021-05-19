//
//  LocalizedString.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import Foundation

public enum LocalizedString: String, Equatable, Hashable {
    // Basic Error
    case notFoundErrorMsg
    case unknownErrorMsg
    case noInternectErrorMsg
    case serverErrorMsg
    
    // Title
    case loginTitle
    case registerTitle
    case calendarTitle
    case mealTitle
    case noticeTitle
    case introduceTitle
    case introduceSubtitle
    case mypageTitle
    
    // Common
    case cancel
    case confirm
    
    // Tab bar
    case calendar
    case meal
    case notice
    case introduce
    case mypage
    
    // Placeholder
    case nicknamePlaceholder
    case newNicknamePlaceholder
    case emailPlaceholder
    case passwordPlaceholder
    case rePasswordPlaceholder
    case currentPasswordPlaceholder
    case newPasswordPlaceholder
    case reNewPasswordPlaceholder
    case commentPlaceholder
    case calendarPlaceholder
    case searchNoticePlaceholder
    case searchLetterPlaceholder
    case noStudentPlaceholder
    case noAuthPlaceholder
    
    // Auth
    case loginButton
    case registerButton
    case notFoundUserErrorMsg
    case existUserErrorMsg
    case notMatchPasswordErrorMsg
    
    // Calendar
    
    // Meal
    case breakfast
    case lunch
    case dinner
    
    // Notice
    case preview
    
    // Introduce
    case clubTitle
    case clubSubtitle
    case clubMember
    case companyTitle
    case companySubtitle
    case companySite
    case companyAddress
    case developerTitle
    case developerSubtitle
    case childClub
    
    // Mypage
    case plusScore
    case minusScore
    case toAddStudent
    case weekStatus
    case weekendMealStatus
    case toOutingList
    case toChangePassword
    case toLogout
    case logoutConfirmMsg
    case enterStudentCodeMsg
    case addStudentButton
    case deleteStudentMsg
    case scoreListTitle
    case outingListTitle
    case outingReason
    case outingPlace
    
    // Mypage - changePassword
    case changePasswordTitle
    case currentPassword
    case newPassword
    case reNewPassword
    case changePasswordConfirmMsg
    case notMatchCurrentPasswordErrorMsg
}

extension LocalizedString {
    var localized: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
    
}
