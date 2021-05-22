//
//  DefaultLoginRepository.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import Moya
import RxMoya
import RxSwift

final class DefaultLoginRepository: LoginRepository {
    let provider: MoyaProvider<AuthApi>
    
    init(provider: MoyaProvider<AuthApi>?) {
        self.provider = provider ??  MoyaProvider<AuthApi>()
    }
    
    func login(email: String, password: String) -> Single<Bool> {
        provider.rx.request(.login(email: email, password: password))
            .filterSuccessfulStatusCodes()
            .map(AccessToken.self)
            .map {
                StorageManager.shared.createUser(
                    user: Auth(token: $0.accessToken, email: email, password: password))
                return true
            }
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
