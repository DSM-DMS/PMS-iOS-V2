//
//  User.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import Foundation

public struct User: Codable, Equatable {
    public static func == (lhs: User, rhs: User) -> Bool {
        lhs.name == rhs.name
    }
    
    public var name: String
    public var students: [UsersStudent]
    
    public init(name: String, students: [UsersStudent]) {
        self.name = name
        self.students = students
    }
}

public struct UsersStudent: Codable {
    public var name: String
    public var number: Int
    
    enum CodingKeys: String, CodingKey {
        case name = "student-name"
        case number = "student-number"
    }
    
    public init(name: String, number: Int) {
        self.name = name
        self.number = number
    }
}
