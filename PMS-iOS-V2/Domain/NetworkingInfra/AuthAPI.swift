//
//  AuthAPI.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/18.
//

import Foundation
import Moya

public enum AuthApi {
    // Auth
    case login(email: String, password: String)
    case register(email: String, password: String, name: String)
    
    // Mypage
    case mypage(number: Int)
    case changeNickname(name: String)
    case addStudent(number: Int)
    case userInform
    case deleteStudent(number: Int)
    case outing(number: Int)
    case changePassword(password: String, prePassword: String)
    case pointList(number: Int)
    
    // FCM Token
    case notification(token: String)
    
    // OAuth
    case naver(token: String)
    case facebook(token: String)
    case kakaotalk(token: String)
    case apple(token: String)
}

extension AuthApi: TargetType {
    public var baseURL: URL {
        return URL(string: "https://api.smooth-bear.live")!
    }
    
    public var path: String {
        switch self {
        // Auth
        case .login:
            return "/auth"
        case .register:
            return "/user"
            
        // Mypage
        case .mypage(let number):
            return "/user/student/\(number)"
        case .changeNickname:
            return "/user/name"
        case .addStudent:
            return "/user/student"
        case .userInform:
            return "/user"
        case .outing(let number):
            return "/user/student/outing/\(number)"
        case .changePassword:
            return "/auth/password"
        case .pointList(let number):
            return "/user/student/point/\(number)"
        case .deleteStudent:
            return "/user/student"
        case .notification:
            return "/notification"
        case .naver:
            return "/oauth2/authorize/naver"
        case .facebook:
            return "/oauth2/authorize/facebook"
        case .kakaotalk:
            return "/oauth2/authorize/kakaotalk"
        case .apple:
            return "/oauth2/authorize/apple"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .login, .register, .addStudent, .notification, .naver, .kakaotalk:
            return .post
        case .changePassword, .changeNickname:
            return .put
        case .deleteStudent:
            return .delete
        default:
            return .get
        }
    }
    
    // 기본요청(plain request), 데이터 요청(data request), 파라미터 요청(parameter request), 업로드 요청(upload request) 등
    public var task: Task {
        switch self {
        case let .register(email, password, name):
            return .requestParameters(parameters: ["email": email, "password": password, "name": name], encoding: JSONEncoding.default)
        case let .login(email, password):
            return .requestParameters(parameters: ["email": email, "password": password], encoding: JSONEncoding.default)
        case let .changePassword(password, prePassword):
            return .requestParameters(parameters: ["password": password, "pre-password": prePassword], encoding: JSONEncoding.default)
        case let.addStudent(number):
            return .requestParameters(parameters: ["number": number], encoding: JSONEncoding.default)
        case let .changeNickname(name):
            return .requestParameters(parameters: ["name": name], encoding: JSONEncoding.default)
        case let.deleteStudent(number):
            return .requestParameters(parameters: ["number": number], encoding: JSONEncoding.default)
        case let .notification(token):
            return .requestParameters(parameters: ["token": token], encoding: JSONEncoding.default)
        case let .naver(token):
            return .requestParameters(parameters: ["token": token], encoding: URLEncoding.queryString)
        case let .facebook(token):
            return .requestParameters(parameters: ["token": token], encoding: URLEncoding.queryString)
        case let .kakaotalk(token):
            return .requestParameters(parameters: ["token": token], encoding: URLEncoding.queryString)
        default:
            return .requestPlain
        }
    }
    
    public var headers: [String: String]? {
        switch self {
        case .login, .register:
            return ["Content-type": "application/json"]
        default:
            let token = StorageManager.shared.readUser() == nil ? "" : StorageManager.shared.readUser()!.token
            return ["Authorization": "Bearer " + token]
        }
    }
    
    public var sampleData: Data {
        switch self {
        case .login:
            return stub("loginSuccess")
        case .userInform:
            return stub("User")
        case .mypage:
            return stub("Student")
        case .pointList:
            return stub("PointList")
        case .outing:
            return stub("OutingList")
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
}
