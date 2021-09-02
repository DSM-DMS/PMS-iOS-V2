//
//  UserDefaults+App Group.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/09/01.
//

import Foundation

extension UserDefaults {
    static var shared: UserDefaults {
        let appGroupId = "group.com.dsm.pms-v2"
        return UserDefaults(suiteName: appGroupId)!
    }
}
