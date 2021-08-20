//
//  AccessToken.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import Foundation

public struct AccessToken: Codable {
    public var accessToken: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access-token"
    }
}
