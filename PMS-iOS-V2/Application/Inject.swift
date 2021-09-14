//
//  Inject.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/09/13.
//

import Foundation

@propertyWrapper
class Inject<T> {
    
    let wrappedValue: T
    
    init() {
        self.wrappedValue = AppDelegate.container.resolve(T.self)!
    }
}
