//
//  DefaultNoticeRepository.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import Moya
import RxSwift

final public class DefaultNoticeRepository: NoticeRepository {
    private let provider: MoyaProvider<PMSApi>
    
    public init(provider: MoyaProvider<PMSApi>?) {
        self.provider = provider ?? MoyaProvider<PMSApi>()
    }
    
    public func getNoticeList(page: Int) -> Single<[Notice]> {
        provider.rx.request(.notice(page))
            .filterSuccessfulStatusCodes()
            .retryWithAuthIfNeeded()
            .map([Notice].self)
            .catchError { error in
                if let moyaError = error as? MoyaError {
                    return Single.error(NetworkError(moyaError))
                } else {
                    Log.error("Unkown Error!")
                    return Single.error(NetworkError.unknown)
                }
            }
    }
    
    public func getDetailNotice(id: Int) -> Single<DetailNotice> {
        provider.rx.request(.noticeDetail(id))
            .filterSuccessfulStatusCodes()
            .retryWithAuthIfNeeded()
            .map(DetailNotice.self)
            .catchError { error in
                if let moyaError = error as? MoyaError {
                    return Single.error(NetworkError(moyaError))
                } else {
                    Log.error("Unkown Error!")
                    return Single.error(NetworkError.unknown)
                }
            }
    }
}
