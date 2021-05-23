//
//  ListSection.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/23.
//

import Foundation
import RxDataSources

struct ListSection<T> {
    let header: String
    var items: [T]
}

extension ListSection: SectionModelType {
    init(original: ListSection, items: [T]) {
        self = original
        self.items = items
    }
}
