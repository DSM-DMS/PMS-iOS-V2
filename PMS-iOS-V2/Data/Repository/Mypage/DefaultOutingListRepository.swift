//
//  DefaultOutingListRepository.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import Foundation
import RxSwift
import Moya

final class DefaultOutingListRepository: OutingListRepository {
    let provider: MoyaProvider<AuthApi>
    
    init(provider: MoyaProvider<AuthApi>?) {
        self.provider = provider ??  MoyaProvider<AuthApi>()
    }
    
    func getOutingList(number: Int) -> Single<OutingList> {
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
