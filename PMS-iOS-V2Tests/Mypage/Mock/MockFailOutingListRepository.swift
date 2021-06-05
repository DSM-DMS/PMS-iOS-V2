//
//  MockFailOutingListRepository.swift
//  PMS-iOS-V2Tests
//
//  Created by GoEun Jeong on 2021/05/30.
//

import Foundation
import RxSwift

@testable import PMS_iOS_V2

final class MockFailOutingListRepository: OutingListRepository {
    var error = NetworkError.unknown
    
    enum Test {
        case noInternet
    }
    
    init(test: Test) {
        switch test {
        case .noInternet:
            self.error = NetworkError.noInternet
        }
    }
    
    func getOutingList(number: Int) -> Single<OutingList> {
        return Single.error(error)
    }
}
