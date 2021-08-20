//
//  ListSection.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/23.
//

import Foundation
import RxDataSources

public struct ListSection<T> {
    public let header: String
    public var items: [T]
    
    public init(header: String, items: [T]) {
        self.header = header
        self.items = items
    }
}

extension ListSection: SectionModelType {
    public init(original: ListSection, items: [T]) {
        self = original
        self.items = items
    }
}
