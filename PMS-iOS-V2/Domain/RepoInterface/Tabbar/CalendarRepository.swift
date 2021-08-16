//
//  CalendarRepository.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import Foundation
import RxSwift

public protocol CalendarRepository {
    func getCalendar() -> Single<PMSCalendar>
}
