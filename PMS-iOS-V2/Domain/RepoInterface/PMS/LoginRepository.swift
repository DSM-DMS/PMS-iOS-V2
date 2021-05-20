//
//  LoginRepository.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import Foundation
import RxSwift
import Moya

protocol LoginRepository {
    func login(email: String, password: String) -> Single<Void>
}
