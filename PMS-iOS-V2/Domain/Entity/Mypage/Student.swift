//
//  Student.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import Foundation

public struct Student: Codable {
    public var plus: Int
    public var minus: Int
    public var status: Int
    public var isMeal: Bool
    
    enum CodingKeys: String, CodingKey {
        case plus = "bonus-point"
        case minus = "minus-point"
        case status = "stay-status"
        case isMeal = "meal-applied"
    }
    
    public init(plus: Int, minus: Int, status: Int, isMeal: Bool) {
        self.plus = plus
        self.minus = minus
        self.status = status
        self.isMeal = isMeal
    }
}
