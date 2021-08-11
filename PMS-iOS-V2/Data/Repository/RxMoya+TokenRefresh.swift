//
//  RxMoya+TokenRefresh.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/24.
//

import Moya
import RxMoya
import RxSwift

extension PrimitiveSequence where Trait == SingleTrait, Element == Response {
    public func retryWithAuthIfNeeded() -> Single<Element> {
        let provider = MoyaProvider<AuthApi>()
        let user = StorageManager.shared.readUser() ?? Auth(token: "", email: "", password: "")
        return retryWhen { error in
            Observable.zip(error, Observable.range(start: 1, count: 3),
                           resultSelector: { $1 })
                .flatMap { _ -> Single<AccessToken> in
                    return provider.rx
                        .request(.login(email: user.email, password: user.password))
                        .filterSuccessfulStatusCodes()
                        .map(AccessToken.self)
                        .catchError { error in
                            return Single.error(NetworkError.unknown)
                        }.flatMap({ access -> Single<AccessToken> in
                            StorageManager.shared.updateUser(user: Auth(token: access.accessToken, email: user.email, password: user.password))
                            return Single.just(access)
                        })
            }
        }
    }
}
