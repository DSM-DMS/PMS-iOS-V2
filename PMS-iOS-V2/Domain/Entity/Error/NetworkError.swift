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
    case ok = 200
    case unauthorized = 401
    case notFound = 404
    case conflict = 409
    case serverError = 500
    case badGateway = 502
    
    public init?(_ error: Error) {
        guard let code = (error as? MoyaError)?.response?.statusCode,
              let networkError = NetworkError(rawValue: code) else { return nil }
        self = networkError
    }
    
    public var message: LocalizedString {
        switch self {
        case .notFound: return .notFoundErrorMsg
        case .conflict: return .existUserErrorMsg
        case .serverError: return .serverErrorMsg
        default: return .unknownErrorMsg
        }
    }
}
