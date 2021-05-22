//
//  MockFailLoginRepository.swift
//  PMS-iOS-V2Tests
//
//  Created by GoEun Jeong on 2021/05/22.
//

import RxSwift
@testable import PMS_iOS_V2

final class MockFailLoginRepository: LoginRepository {
    var error = NetworkError.unknown
    
    enum Test {
        case noInternet
        case notMatch
    }
    
    init(test: Test) {
        switch test {
        case .noInternet:
            self.error = NetworkError.noInternet
        case .notMatch:
            self.error = NetworkError.error
        }
    }
    
    func login(email: String, password: String) -> Single<Bool> {
        return Single.error(error)
    }
}
