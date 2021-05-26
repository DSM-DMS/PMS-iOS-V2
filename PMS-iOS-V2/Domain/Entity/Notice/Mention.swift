//
//  Mention.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/26.
//

import Foundation

public struct Mention: Decodable, Hashable {
    public var text: String
    
    public init(text: String) {
        self.text = text
    }
}
