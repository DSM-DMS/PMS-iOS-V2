//
//  NetworkError.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import Foundation
import Moya

public enum NetworkError: Int, Error {
    case unknown = 0
    case noInternet = 1
    case ok = 200
    case error = 400
    case unauthorized = 401
    case notFound = 404
    case conflict = 409
    case serverError = 500
    case badGateway = 502
    
    public init(_ error: MoyaError) {
        if error.response == nil {
            self = .noInternet
        } else {
            let code = error.response!.statusCode
            Log.info("Status code: \(code)")
            let networkError = NetworkError(rawValue: code)
            self = networkError ?? .unknown
        }
    }
    
    public var message: String {
        switch self {
        case .noInternet: return LocalizedString.noInternetErrorMsg.localized
        case .error: return LocalizedString.notFoundUserErrorMsg.localized
        case .unauthorized: return LocalizedString.unauthorizedErrorMsg.localized
        case .notFound: return LocalizedString.notFoundErrorMsg.localized
        case .conflict: return LocalizedString.existUserErrorMsg.localized
        case .serverError: return LocalizedString.serverErrorMsg.localized
        default: return LocalizedString.unknownErrorMsg.localized
        }
    }
}
