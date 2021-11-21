//
//  Student.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import Foundation

public struct Student: Codable, Equatable {
    public var plus: Int
    public var minus: Int
    public var status: Int
    public var mealStatus: Int
    
    enum CodingKeys: String, CodingKey {
        case plus = "bonus-point"
        case minus = "minus-point"
        case status = "stay"
        case mealStatus = "meal-apply"
    }
    
    public init(plus: Int, minus: Int, status: Int, mealStatus: Int) {
        self.plus = plus
        self.minus = minus
        self.status = status
        self.mealStatus = mealStatus
    }
}
