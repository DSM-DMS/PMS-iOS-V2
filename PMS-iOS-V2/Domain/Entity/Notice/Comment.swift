//
//  Comment.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/24.
//

import Foundation

public struct Comment: Codable, Hashable {
    public var id: Int
    public var date: String
    public var body: String
    public var user: CommentUser
    public var comment: [Comment]
    
    enum CodingKeys: String, CodingKey {
        case id
        case date = "upload-date"
        case body
        case user
        case comment
    }
}

public struct CommentUser: Codable, Hashable {
    public var email: String
    public var name: String
    public var userRole: String
    
    enum CodingKeys: String, CodingKey {
        case email
        case name
        case userRole = "user_role"
    }
}
