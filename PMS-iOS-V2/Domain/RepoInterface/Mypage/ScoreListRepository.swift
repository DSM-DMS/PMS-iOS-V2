//
//  ScoreListRepository.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import Foundation
import RxSwift
import Moya

class ScoreListRepository {
    let provider: MoyaProvider<AuthApi>
    
    init(provider: MoyaProvider<AuthApi> = MoyaProvider<AuthApi>()) {
        self.provider = provider
    }
}
