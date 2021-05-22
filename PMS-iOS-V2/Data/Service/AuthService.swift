//
//  AuthService.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/22.
//

import Foundation
import Moya

class AuthService {
    static let shared = AuthService()
    private let provider = MoyaProvider<AuthApi>()
    var user: Auth?
    
    public init() {}
    
    func refreshToken() {
        user = StorageManager.shared.readUser()!
        self.requestToken()
    }
    
    func requestToken() {
        provider.rx.request(.login(email: user!.email, password: user!.password))
            .map(AccessToken.self)
            .map { _ in
                StorageManager.shared.updateUser(user: self.user!)
                return
            }.subscribe(onError: {
                Log.error($0.localizedDescription)
            })
    }
}
