//
//  MockFailIntroduceRepository.swift
//  PMS-iOS-V2Tests
//
//  Created by GoEun Jeong on 2021/05/27.
//

import RxSwift
@testable import PMS_iOS_V2

final class MockFailIntroduceRepository: IntroduceRepository {
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
    
    func getClubList() -> Single<ClubList> {
        return Single.error(error)
    }
    
    func getDetailClub(name: String) -> Single<DetailClub> {
        return Single.error(error)
    }
    
    func getDeveloper() -> Single<[Developer]> {
        return Single.error(error)
    }
}
