//
//  Notice.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/24.
//

import Foundation

public struct NoticeCell: Decodable, Hashable {
    public var type: Bool
    public var notice: Notice
    
    public init(type: Bool = false, notice: Notice) {
        self.type = type
        self.notice = notice
    }
}

public struct Notice: Codable, Hashable {
    public var id: Int
    public var date: String
    public var title: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case date = "upload-date"
        case title
    }
    
    public init(id: Int, date: String, title: String) {
        self.id = id
        self.date = date
        self.title = title
    }
}

public struct DetailNotice: Codable, Hashable {
    public var id: Int
    public var date: String
    public var title: String
    public var body: String
//    public var attach
    public var comment: [Comment]
    
    public init(id: Int, date: String, title: String, body: String, comment: [Comment]) {
        self.id = id
        self.date = date
        self.title = title
        self.body = body
        self.comment = comment
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case date = "upload-date"
        case title
        case body
        case comment
    }
}
