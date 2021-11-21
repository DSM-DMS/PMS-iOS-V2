//
//  CalendarCell.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/11/12.
//

import Foundation

public struct CalendarCell: Equatable {
    public var date: String?
    public var event: String
    public var isHome: Bool?
    
    public init(date: String, event: String, isHome: Bool) {
        self.date = date
        self.event = event
        self.isHome = isHome
    }
    
    public init(label: LocalizedString) {
        self.date = nil
        self.event = label.localized
        self.isHome = nil
    }
}
