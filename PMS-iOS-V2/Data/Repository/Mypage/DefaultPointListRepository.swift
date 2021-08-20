//
//  DefaultS coreListRepository.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import Moya
import RxSwift

final public class DefaultPointListRepository: PointListRepository {
    private let provider: MoyaProvider<AuthApi>
    
    public init(provider: MoyaProvider<AuthApi>?) {
        self.provider = provider ?? MoyaProvider<AuthApi>()
    }
    
    public func getPointList(number: Int) -> Single<PointList> {
        provider.rx.request(.pointList(number: number))
            .filterSuccessfulStatusCodes()
            .retryWithAuthIfNeeded()
            .map(PointList.self)
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
