//
//  LoginRepository.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import Foundation
import RxSwift

protocol LoginRepository {
    func login(email: String, password: String) -> Single<Bool>
    func sendNaverToken(token: String) -> Single<Bool>
    func sendFacebookToken(token: String) -> Single<Bool>
    func sendKakaotalkToken(token: String) -> Single<Bool>
}
