//
//  User.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/22.
//

import Foundation

public struct Auth: Codable {
    public var token: String
    public var email: String
    public var password: String
    
    public init(token: String, email: String, password: String) {
        self.token = token
        self.email = email
        self.password = password
    }
}
