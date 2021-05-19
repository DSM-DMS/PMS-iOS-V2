//
//  CompanyRepository.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import Foundation
import RxSwift
import Moya

class CompanyRepository {
    let provider: MoyaProvider<PMSApi>
    
    init(provider: MoyaProvider<PMSApi> = MoyaProvider<PMSApi>()) {
        self.provider = provider
    }
    
}
