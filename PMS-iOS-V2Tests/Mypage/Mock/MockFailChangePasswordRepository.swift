//
//  MockFailChangePasswordRepository.swift
//  PMS-iOS-V2Tests
//
//  Created by GoEun Jeong on 2021/05/29.
//

import Foundation
import RxSwift

@testable import PMS_iOS_V2

final class MockFailChangePasswordRepository: ChangePasswordRepository {
    
    var error = NetworkError.unknown
    
    enum Test {
        case noInternet
        case notMatchPassword
    }
    
    init(test: Test) {
        switch test {
        case .noInternet:
            self.error = NetworkError.noInternet
        case .notMatchPassword:
            self.error = NetworkError.notMatch
        }
    }
    
    func changePassword(nowPassword: String, newPassword: String) -> Single<Bool> {
        return Single.error(error)
    }
}
