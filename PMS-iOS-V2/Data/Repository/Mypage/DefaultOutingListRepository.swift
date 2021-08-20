//
//  DefaultOutingListRepository.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import RxSwift
import Moya

final public class DefaultOutingListRepository: OutingListRepository {
    private let provider: MoyaProvider<AuthApi>
    
    public init(provider: MoyaProvider<AuthApi>?) {
        self.provider = provider ??  MoyaProvider<AuthApi>()
    }
    
    public func getOutingList(number: Int) -> Single<OutingList> {
        provider.rx.request(.outing(number: number))
            .filterSuccessfulStatusCodes()
            .retryWithAuthIfNeeded()
            .map(OutingList.self)
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
