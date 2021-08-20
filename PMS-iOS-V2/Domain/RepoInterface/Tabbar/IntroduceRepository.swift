//
//  IntroduceRepository.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import UIKit
import RxSwift

public protocol IntroduceRepository {
    func getClubList() -> Single<ClubList>
    func getDetailClub(name: String) -> Single<DetailClub>
    func getDeveloper() -> Single<[Developer]>
}
