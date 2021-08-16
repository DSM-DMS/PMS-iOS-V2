//
//  MockNoticeRepository.swift
//  PMS-iOS-V2Tests
//
//  Created by GoEun Jeong on 2021/05/25.
//

import RxSwift
@testable import PMS_iOS_V2

final class MockNoticeRepository: NoticeRepository {
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
    
    func getNoticeList(page: Int) -> Single<[Notice]> {
        Single.error(error)
    }
    
    func getDetailNotice(id: Int) -> Single<DetailNotice> {
        Single.error(error)
    }
 }
