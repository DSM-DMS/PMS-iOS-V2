//
//  PMSFlow.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import RxFlow
import UIKit

public enum PMSStep: Step, Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
            switch (lhs, rhs) {
            case let (.alert(lhsStr, lhsAccess), .alert(rhsStr, rhsAccess)):
                return lhsStr == rhsStr && lhsAccess == rhsAccess
            case let (.success(lhsStr), .success(rhsStr)):
                return lhsStr == rhsStr
            case (.dismiss, .dismiss):
                return true
            case (.tabBarIsRequired, .tabBarIsRequired):
                return true
            case (.PMSIsRequired, .PMSIsRequired):
                return true
            case (.loginIsRequired, .loginIsRequired):
                return true
            case (.registerIsRequired, .registerIsRequired):
                return true
            case (.calendarIsRequired, .calendarIsRequired):
                return true
            case (.mealIsRequired, .mealIsRequired):
                return true
            case (.noticeIsRequired, .noticeIsRequired):
                return true
            case let (.detailNoticeIsRequired(lhsId, lhsStr, lhsSeg), .detailNoticeIsRequired(rhsId, rhsStr, rhsSeg)):
                return lhsId == rhsId && lhsStr == rhsStr && lhsSeg == rhsSeg
            case (.introduceIsRequired, .introduceIsRequired):
                return true
            case (.clubIsRequired, .clubIsRequired):
                return true
            case let (.detailClubIsRequired(lhsStr), .detailClubIsRequired(rhsStr)):
                return lhsStr == rhsStr
            case (.companyIsRequired, .companyIsRequired):
                return true
            case let (.detailCompanyIsRequired(lhsStr), .detailCompanyIsRequired(rhsStr)):
                return lhsStr == rhsStr
            case (.developerIsRequired, .developerIsRequired):
                return true
            case (.mypageIsRequired, .mypageIsRequired):
                return true
            case let (.pointListIsRequired(lhsId), .pointListIsRequired(rhsId)):
                return lhsId == rhsId
            case let (.outingListIsRequired(lhsId), .outingListIsRequired(rhsId)):
                return lhsId == rhsId
            case (.changePasswordIsRequired, .changePasswordIsRequired):
                return true
            case (.logout, .logout):
                return true
            case let (.deleteStudent(lhsStr, _), .deleteStudent(rhsStr, _)):
                return lhsStr == rhsStr
            case (.dismissTabbar, .dismissTabbar):
                return true
            case (.presentTabbar, .presentTabbar):
                return true
            default:
                return false
            }
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

    // Notice
    case noticeIsRequired
    case detailNoticeIsRequired(id: Int, title: String, segment: Int)
    
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
