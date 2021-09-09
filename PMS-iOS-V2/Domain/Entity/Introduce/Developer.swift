//
//  Developer.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/27.
//

import UIKit

public struct Developer: Equatable {
    public var name: String
    public var field: String
    public var image: String
    
    public init(name: String, field: String, image: String) {
        self.name = name
        self.field = field
        self.image = image
    }
}
