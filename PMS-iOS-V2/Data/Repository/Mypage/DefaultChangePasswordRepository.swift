//
//  DefaultChangePasswordRepository.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import Foundation
import RxSwift
import Moya

final class DefaultChangePasswordRepository: ChangePasswordRepository {
    let provider: MoyaProvider<AuthApi>
    
    init(provider: MoyaProvider<AuthApi>?) {
        self.provider = provider ?? MoyaProvider<AuthApi>()
    }
    
    func changePassword(nowPassword: String, newPassword: String) -> Single<Bool> {
        provider.rx.request(.changePassword(password: newPassword, prePassword: nowPassword))
            .filterSuccessfulStatusCodes()
            .retryWithAuthIfNeeded()
            .map { _ in
                var preUser = StorageManager.shared.readUser()!
                preUser.password = newPassword
                StorageManager.shared.updateUser(user: preUser)
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
