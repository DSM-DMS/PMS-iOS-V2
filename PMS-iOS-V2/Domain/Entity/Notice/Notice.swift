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

public struct NoticeList: Codable, Hashable {
    public var totalPage: Int
    public var notices: [Notice]
    
    enum CodingKeys: String, CodingKey {
        case totalPage  = "total_page"
        case notices
    }
    
    public init(totalPage: Int, notices: [Notice]) {
        self.totalPage = totalPage
        self.notices = notices
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

public struct AlbumList: Codable, Hashable {
    public var totalPage: Int
    public var totalLength: Int
    public var albums: [Album]
    
    enum CodingKeys: String, CodingKey {
        case albums  = "galleries"
        case totalPage = "total_page"
        case totalLength = "total_length"
    }
    
    public init(totalPage: Int, totalLength: Int, albums: [Album]) {
        self.totalPage = totalPage
        self.totalLength = totalLength
        self.albums = albums
    }
}

public struct Album: Codable, Hashable {
    public var id: Int
    public var date: String
    public var title: String
    public var thumbnail: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case date = "upload-date"
        case title
        case thumbnail
    }
    
    public init(id: Int, date: String, title: String, thumbnail: String) {
        self.id = id
        self.date = date
        self.title = title
        self.thumbnail = thumbnail
    }
}

public struct DetailNotice: Codable, Hashable {
    public var id: Int
    public var date: String
    public var title: String
    public var writer: String?
    public var body: String
    public var attach: [Attach]
    public var comment: [Comment]
    
    public init(id: Int, date: String, title: String, writer: String?, body: String, attach: [Attach], comment: [Comment]) {
        self.id = id
        self.date = date
        self.title = title
        self.writer = writer
        self.body = body
        self.attach = attach
        self.comment = comment
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case date = "upload-date"
        case title
        case writer
        case body
        case attach
        case comment
    }
}

public struct Attach: Codable, Hashable {
    public var download: String
    public var name: String
}

public struct DetailAlbumResponse: Codable, Hashable {
    public var gallery: DetailAlbum
}

public struct DetailAlbum: Codable, Hashable {
    public var id: Int
    public var date: String
    public var title: String
    public var body: String
    public var attach: [String]
    public var thumbnail: String
    
    public init(id: Int, date: String, title: String, body: String, attach: [String], thumbnail: String) {
        self.id = id
        self.date = date
        self.title = title
        self.body = body
        self.attach = attach
        self.thumbnail = thumbnail
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case date = "upload-date"
        case title
        case body
        case attach
        case thumbnail
    }
}
