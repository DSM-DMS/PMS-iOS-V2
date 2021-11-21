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
    case notice(_ page: Int)
    case letter(_ page: Int)
    case album(_ page: Int)
    case noticeDetail(_ id: Int)
    case albumDetail(_ id: Int)
    case searchNotice(_ string: String)
    case searchLetter(_ string: String)
    
    case addComment(_ id: Int, _ body: String)
    
    // Introduce
    case clubs
    case clubDetail(_ name: String)
    case companys
    case companyDetail(_ id: Int)
    
}

extension PMSApi: TargetType {
    public var baseURL: URL {
        return URL(string: "https://api.potatochips.live")!
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
            return "/notice/news"
        case .album:
            return "/gallery"
        case .noticeDetail(let id):
            return "/notice/\(id)"
        case .albumDetail(let id):
            return "/gallery/\(id)"
        case .searchNotice:
            return "/notice/search"
        case .searchLetter:
            return "/notice/news/search"
        case .addComment(let id, _):
            return "/notice/\(id)/comment"
            
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
        case .notice(let page):
            return .requestParameters(parameters: ["page": page, "size": 6], encoding: URLEncoding.queryString)
        case .letter(let page):
            return .requestParameters(parameters: ["page": page, "size": 6], encoding: URLEncoding.queryString)
        case .album(let page):
            return .requestParameters(parameters: ["page": page, "size": 6], encoding: URLEncoding.queryString)
        case .searchNotice(let string):
            return .requestParameters(parameters: ["q": string], encoding: URLEncoding.queryString)
        case .searchLetter(let string):
            return .requestParameters(parameters: ["q": string], encoding: URLEncoding.queryString)
        case .addComment(_, let body):
            return .requestParameters(parameters: ["body": body], encoding: URLEncoding.default)
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
