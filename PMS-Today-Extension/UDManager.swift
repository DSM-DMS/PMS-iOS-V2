//
//  UDManager.swift
//  PMS-Today-Extension
//
//  Created by GoEun Jeong on 2021/08/20.
//

import Foundation

final public class UDManager {
    static let shared = UDManager()
    
    private let UD = UserDefaults.standard
    
    public var response: PMSCalendar? {
        get {
            UserDefaults.standard.value(forKey: "PMSCalendar") as? PMSCalendar
        } set(value) {
            UD.set(value, forKey: "PMSCalendar")
        }
    }
    
    public var dateInHome: [[String]]? {
        get {
            UserDefaults.standard.value(forKey: "dateInHome") as? [[String]]
        } set(value) {
            UD.set(value, forKey: "dateInHome")
        }
    }
    
    public var dateInSchool: [[String]]? {
        get {
            UserDefaults.standard.value(forKey: "dateInSchool") as? [[String]]
        } set(value) {
            UD.set(value, forKey: "dateInSchool")
        }
    }
}
