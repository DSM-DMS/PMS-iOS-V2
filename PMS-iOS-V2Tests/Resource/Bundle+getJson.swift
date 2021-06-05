//
//  Bundle+getJson.swift
//  PMS-iOS-V2Tests
//
//  Created by GoEun Jeong on 2021/05/23.
//

import Foundation
@testable import PMS_iOS_V2

extension Bundle {
    static let bundlePath = Bundle.main.path(forResource: "Stub", ofType: "bundle")
    static let bundle = Bundle(path: bundlePath!)
    
    static func getCalendarJson() -> PMSCalendar {
        return bundle!.decode(PMSCalendar.self, from: "Calendar.json")
    }
    
    static func getNoticeListJson() -> [NoticeCell] {
        return bundle!.decode([Notice].self, from: "Notice.json").map { NoticeCell(notice: $0) }
    }
    
    static func getDetialNoticeJson() -> DetailNotice {
        return bundle!.decode(DetailNotice.self, from: "NoticeDetail.json")
    }
    
    static func getClubListJson() -> [Club] {
        let clubList = bundle!.decode(ClubList.self, from: "ClubList.json")
        
        return clubList.clubs.map { return Club(name: $0.name, imageUrl: $0.imageUrl.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!.replacingOccurrences(of: "%3A", with: ":")) }

    }
    
    static func getDetialClubJson() -> DetailClub {
        return bundle!.decode(DetailClub.self, from: "ClubDetail.json")
    }
    
    static func getPointListJson() -> [Point] {
        return bundle!.decode(PointList.self, from: "PointList.json").points
    }
    
    static func getOutingListJson() -> [Outing] {
        return bundle!.decode(OutingList.self, from: "OutingList.json").outings
    }
    
    static func getUserJson() -> User {
        return bundle!.decode(User.self, from: "User.json")
    }
    
    static func getStudentStatusJson() -> Student {
        return bundle!.decode(Student.self, from: "Student.json")
    }
    
    static func getDevelopers() -> [Developer] {
        return [
            Developer(name: "정고은", field: "iOS", image: Asset.ios1.image),
            Developer(name: "강은빈", field: "웹", image: Asset.front1.image),
            Developer(name: "이진우", field: "웹", image: Asset.front2.image),
            Developer(name: "정지우", field: "서버", image: Asset.back1.image),
            Developer(name: "김정빈", field: "서버", image: Asset.back2.image),
            Developer(name: "이은별", field: "안드로이드", image: Asset.android1.image),
            Developer(name: "김재원", field: "안드로이드", image: Asset.android2.image)]
    }
}

// MARK: - TO TEST

extension Bundle {
    func decode<T: Decodable>(_ type: T.Type, from file: String, dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate, keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = dateDecodingStrategy
        decoder.keyDecodingStrategy = keyDecodingStrategy

        do {
            return try decoder.decode(T.self, from: data)
        } catch let DecodingError.keyNotFound(key, context) {
            fatalError("Failed to decode \(file) from bundle due to missing key '\(key.stringValue)' not found – \(context.debugDescription)")
        } catch let DecodingError.typeMismatch(_, context) {
            fatalError("Failed to decode \(file) from bundle due to type mismatch – \(context.debugDescription)")
        } catch let DecodingError.valueNotFound(type, context) {
            fatalError("Failed to decode \(file) from bundle due to missing \(type) value – \(context.debugDescription)")
        } catch DecodingError.dataCorrupted(_) {
            fatalError("Failed to decode \(file) from bundle because it appears to be invalid JSON")
        } catch {
            fatalError("Failed to decode \(file) from bundle: \(error.localizedDescription)")
        }
    }
}
