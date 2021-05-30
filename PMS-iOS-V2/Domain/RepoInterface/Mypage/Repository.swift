//
//  ScoreListRepository.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import Foundation
import RxSwift

protocol PointListRepository {
    func getPointList(number: Int) -> Single<PointList>
}
