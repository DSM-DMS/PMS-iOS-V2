//
//  Date.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/23.
//

import Foundation
import UIKit

extension Date {
    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}
