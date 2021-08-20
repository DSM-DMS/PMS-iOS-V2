//
//  LocalizedString.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import Foundation

public enum LocalizedString: String, Equatable, Hashable {
    // Basic Error
    case unauthorizedErrorMsg
    case notFoundErrorMsg
    case unknownErrorMsg
    case noInternetErrorMsg
    case serverErrorMsg
    
    // Title
    case PMSTitle
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
    case noEventPlaceholder
    case searchNoticePlaceholder
    case searchLetterPlaceholder
    case noStudentPlaceholder
    case noAuthPlaceholder
    case noMealPlaceholder
    case noMealPicturePlaceholder
    case noOutingPlaceholder
    case noPointListPlaceholder
    case noNoticeListPlaceholder
    
    // Auth
    case loginButton
    case registerButton
    case noLoginButton
    case notFoundUserErrorMsg
    case existUserErrorMsg
    case notMatchPasswordErrorMsg
    case loginSuccessMsg
    case registerSuccessMsg
    case changePasswordSuccessMsg
    
    // Calendar
    case calendarHeaderDateFormat
    case dateFormat
    
    // Meal
    case breakfast
    case lunch
    case dinner
    
    // Notice
    case letter
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
    case pointListTitle
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
    case notMatchStudentErrorMsg
}

extension LocalizedString {
    public var localized: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
    
    public func localizedDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = self.localized
        
        return dateFormatter.string(from: date)
    }
}
