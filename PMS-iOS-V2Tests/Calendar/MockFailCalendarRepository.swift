//
//  MockFailCalendarRepository.swift
//  PMS-iOS-V2Tests
//
//  Created by GoEun Jeong on 2021/05/23.
//

import RxSwift
@testable import PMS_iOS_V2

final class MockFailCalendarRepository: CalendarRepository {
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
    
    func getCalendar() -> Single<PMSCalendar> {
        return Single.error(error)
    }
}
