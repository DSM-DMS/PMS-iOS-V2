//
//  PMSApi.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/18.
//

import Foundation
import Moya

public enum PMSApi {
    // Calendar
    case calendar
    
    // Meal
    case meal(_ date: Int)
    case mealPicture(_ date: Int)
    
    // Notice
    case notice
    case letter
    case noticeDetail(_ id: Int)
    case letterDetail(_ id: Int)
    
    case addComment(_ id: Int)
    case filePath(_ id: Int)
    
    // Introduce
    case clubs
    case clubDetail(_ name: String)
    case companys
    case companyDetail(_ id: Int)
    
}

extension PMSApi: TargetType {
    public var baseURL: URL {
        return URL(string: "http://api.potatochips.live")!
    }
    
    public var path: String {
        switch self {
            
        // Calendar
        case .calendar:
            return "/calendar"
            
        // Meal
        case .meal(let date):
            return "/event/meal/\(date)"
        case .mealPicture(let date):
            return "/event/meal/picture/\(date)"
            
        // Notice
        case .notice:
            return "/notice"
        case .letter:
            return "/notice/home"
        case .noticeDetail(let id):
            return "/notice/\(id)"
        case .letterDetail(let id):
            return "/notice/home/\(id)"
        case .addComment:
            return "/notice/comment"
        case .filePath(let id):
            return "/notice/download/\(id)"
            
        // Introduce
        case .clubs:
            return "/introduce/clubs"
        case .clubDetail(let name):
            return "/introduce/clubs/\(name)"
        case .companys:
            return "/introduce/company"
        case .companyDetail(let id):
            return "/introduce/clubs/\(id)"
            
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .addComment:
            return .post
        default:
            return .get
        }
    }
    
    public var task: Task {
        switch self {
        default:
            return .requestPlain
        }
    }
    
    public var headers: [String: String]? {
        switch self {
        default:
            let token = StorageManager.shared.readUser() == nil ? "" : StorageManager.shared.readUser()!.token
            return ["Authorization": "Bearer " + token]
        }
    }
    
    public var sampleData: Data {
        switch self {
        case .calendar:
            return stub("Calendar")
        case .meal:
            return stub("Meal")
        case .mealPicture:
            return stub("MealPicture")
        case .notice:
            return stub("Notice")
        case .noticeDetail:
            return stub("NoticeDetail")
        case .clubs:
            return stub("ClubList")
        case .clubDetail:
            return stub("ClubDetail")
        default:
            return Data()
        }
    }
    
    func stub(_ filename: String) -> Data! {
        let bundlePath = Bundle.main.path(forResource: "Stub", ofType: "bundle")
        let bundle = Bundle(path: bundlePath!)
        let path = bundle?.path(forResource: filename, ofType: "json")
        return (try? Data(contentsOf: URL(fileURLWithPath: path!)))
    }
    
    // HTTP code가 200에서 299사이인 경우 요청이 성공한 것으로 간주된다.
    public var validationType: ValidationType {
        return .successCodes
    }
}
