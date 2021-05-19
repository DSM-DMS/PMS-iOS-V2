//
//  OutingList.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import Foundation

public struct OutingList: Codable {
    public var outings: [Outing]
    
    public init(outings: [Outing]) {
        self.outings = outings
    }
}

public struct Outing: Codable, Hashable {
    public var date: String
    public var place: String
    public var reason: String
    public var type: String
    
    public init(date: String, place: String, reason: String, type: String) {
        self.date = date
        self.place = place
        self.reason = reason
        self.type = type
    }
}
