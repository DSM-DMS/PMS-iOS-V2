//
//  PointList.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import Foundation

public struct PointList: Codable {
    public var points: [Point]
    
    public init(points: [Point]) {
        self.points = points
    }
}

public struct Point: Codable, Hashable {
    var date: String
    var reason: String
    var point: Int
    var type: Bool
    
    public init(date: String, reason: String, point: Int, type: Bool) {
        self.date = date
        self.reason = reason
        self.point = point
        self.type = type
    }
}
