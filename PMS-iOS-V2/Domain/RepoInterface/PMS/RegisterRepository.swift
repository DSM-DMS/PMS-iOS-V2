//
//  RegisterRepository.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import Foundation
import RxSwift

public protocol RegisterRepository {
    func register(name: String, email: String, password: String) -> Single<Bool>
}
