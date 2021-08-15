//
//  DefaultLoginRepository.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import Moya
import RxSwift

final public class DefaultLoginRepository: LoginRepository {
    private let provider: MoyaProvider<AuthApi>
    
    public init(provider: MoyaProvider<AuthApi>?) {
        self.provider = provider ??  MoyaProvider<AuthApi>()
    }
    
    public func login(email: String, password: String) -> Single<Bool> {
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
    
    public func sendNaverToken(token: String) -> Single<Bool> {
        provider.rx.request(.naver(token: token))
            .filterSuccessfulStatusCodes()
            .map { _ in true }
            .catchError { error in
                if let moyaError = error as? MoyaError {
                    return Single.error(NetworkError(moyaError))
                } else {
                    Log.error("Unkown Error!")
                    return Single.error(NetworkError.unknown)
                }
            }
    }
    
    public func sendFacebookToken(token: String) -> Single<Bool> {
        provider.rx.request(.facebook(token: token))
            .filterSuccessfulStatusCodes()
            .map { _ in true }
            .catchError { error in
                if let moyaError = error as? MoyaError {
                    return Single.error(NetworkError(moyaError))
                } else {
                    Log.error("Unkown Error!")
                    return Single.error(NetworkError.unknown)
                }
            }
    }
    
    public func sendKakaotalkToken(token: String) -> Single<Bool> {
        provider.rx.request(.kakaotalk(token: token))
            .filterSuccessfulStatusCodes()
            .map { _ in true }
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
