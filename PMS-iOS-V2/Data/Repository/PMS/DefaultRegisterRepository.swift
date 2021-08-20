//
//  DefaultRegisterRepository.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import Moya
import RxSwift

final public class DefaultRegisterRepository: RegisterRepository {
    private let provider: MoyaProvider<AuthApi>
    
    public init(provider: MoyaProvider<AuthApi>?) {
        self.provider = provider ?? MoyaProvider<AuthApi>()
    }
    
    public func register(name: String, email: String, password: String) -> Single<Bool> {
        provider.rx.request(.register(email: email, password: password, name: name))
            .filterSuccessfulStatusCodes()
            .flatMap { _ in
                self.provider.rx.request(.login(email: email, password: password))
                    .filterSuccessfulStatusCodes()
                    .map(AccessToken.self)
                    .map {
                        StorageManager.shared.createUser(
                            user: Auth(token: $0.accessToken, email: email, password: password))
                        return true
                    }.catchError { error in
                        if let moyaError = error as? MoyaError {
                            return Single.error(NetworkError(moyaError))
                        } else {
                            Log.error("Unkown Error!")
                            return Single.error(NetworkError.unknown)
                        }
                    }
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
