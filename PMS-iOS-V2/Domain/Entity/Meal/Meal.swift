//
//  Meal.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import Foundation

public struct Meal: Codable, Hashable {
    public var breakfast: [String]
    public var lunch: [String]
    public var dinner: [String]
    
    public init(breakfast: [String], lunch: [String], dinner: [String]) {
        self.breakfast = breakfast
        self.lunch = lunch
        self.dinner = dinner
    }
}

public struct MealPicture: Codable, Hashable {
    public var breakfast: String
    public var lunch: String
    public var dinner: String
    
    public init(breakfast: String, lunch: String, dinner: String) {
        self.breakfast = breakfast
        self.lunch = lunch
        self.dinner = dinner
    }
}

public struct MealCell {
    public var time: LocalizedString
    public var meal: [String]
}
