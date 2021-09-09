//
//  String+filter.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/09/09.
//

import Foundation

extension String {
    public func isEmail() -> Bool {
        if self.contains("@") && self.contains(".") {
            return true
        } else {
            return false
        }
    }
    
    public func isNotEmpty() -> Bool {
        return self != "" // "" -> false, "1" -> true
    }
}
