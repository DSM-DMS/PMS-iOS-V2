//
//  AuthService.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/22.
//

import Foundation
import Moya
import RxSwift

class AuthService {
    static let shared = AuthService()
    private let provider = MoyaProvider<AuthApi>()
    var user: Auth?
    
    public init() {}
    
    func refreshToken() {
        user = StorageManager.shared.readUser()!
        provider.rx.request(.login(email: user!.email, password: user!.password))
            .filterSuccessfulStatusCodes()
            .map(AccessToken.self)
            .map { token in
                print("Token: \(token)")
                StorageManager.shared.updateUser(user: Auth(token: token.accessToken, email: self.user!.email, password: self.user!.password))
                print(StorageManager.shared.readUser()!.token)
                return
            }.subscribe(onError: {
                Log.error($0.localizedDescription)
            })
    }
}
