//
//  TodayViewController.swift
//  PMS-Today-Extension
//
//  Created by GoEun Jeong on 2021/08/19.
//

import UIKit
import NotificationCenter
import FSCalendar
import Alamofire

final public class TodayViewController: UIViewController, NCWidgetProviding {
    @IBOutlet private weak var calendar: FSCalendar!
    private var dateInHome = [String]()
    private var dateInSchool = [String]()
    private var month = Date().get(.month)
    private var currentPage: Date?
    
    private let dateFormatter = DateFormatter()

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ViewDidLoad")
        
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        self.setCalendar()
        self.getData()
    }
    
    private func setCalendar() {
        calendar.appearance.selectionColor = Colors.blue.color
        calendar.appearance.headerDateFormat = LocalizedString.calendarHeaderDateFormat.localized
        calendar.appearance.headerTitleColor = Colors.black.color
        calendar.appearance.weekdayTextColor = Colors.black.color
        let localeID = Locale.preferredLanguages.first
        let deviceLocale = (Locale(identifier: localeID!).languageCode)!
        calendar.locale = Locale(identifier: deviceLocale)
        calendar.appearance.titleFont = UIFont.preferredFont(forTextStyle: .callout)
        calendar.appearance.weekdayFont = UIFont.preferredFont(forTextStyle: .callout)
        calendar.appearance.subtitleFont = UIFont.preferredFont(forTextStyle: .callout)
        calendar.appearance.headerTitleFont = UIFont.preferredFont(forTextStyle: .callout)
        calendar.delegate = self
        calendar.dataSource = self
    }
    
    private func getData() {
        let url = "http://api.potatochips.live/calendar"
        AF.request(url,
                   method: .get,
                   parameters: nil,
                   encoding: URLEncoding.default)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: PMSCalendar.self) { response in
                switch response.result {
                case .success(let calendar):
                    if calendar == UDManager.shared.response { // 데이터 변경 X
                        self.dateInHome = UDManager.shared.dateInHome![self.month]
                        self.dateInSchool = UDManager.shared.dateInSchool![self.month]
                        self.calendar.reloadData()
                        break
                    } else {
                        UDManager.shared.response = calendar
                    }
                    
                    if UDManager.shared.dateInHome == nil { // 비어있으면 Intialize
                        UDManager.shared.dateInHome = [[String]]()
                        UDManager.shared.dateInSchool = [[String]]()
                    }
                    
                    var homeTemp = [String]()
                    var schoolTemp = [String]()
                    
                    for (key, value) in calendar {
                        for (key, value) in value {
                            if value.contains("의무귀가") {
                                homeTemp.append(key)
                            } else if !value.contains("빙학") && !value.contains("토요휴업일") {
                                schoolTemp.append(key)
                            }
                        }
                        UDManager.shared.dateInHome![Int(key)!] = homeTemp
                        UDManager.shared.dateInSchool![Int(key)!] = schoolTemp
                        
                        homeTemp = [String]()
                        schoolTemp = [String]()
                    }
                    
                    self.dateInHome = UDManager.shared.dateInHome![self.month]
                    self.dateInSchool = UDManager.shared.dateInSchool![self.month]
                    print(self.dateInHome)
                    print(self.dateInSchool)
                    self.calendar.reloadData()
                    
                case .failure(_):
                    break
                }
            }
    }
    
    public func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's anb update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
    public func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        preferredContentSize = activeDisplayMode == .expanded ? CGSize(width: maxSize.width, height: 300) : maxSize
    }
    
}

extension TodayViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    public func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        print(dateFormatter.string(from: date))
        if dateInHome.contains(dateFormatter.string(from: date)) {
            return Colors.red.color
        }
        
        if dateInSchool.contains(dateFormatter.string(from: date)) {
            return Colors.green.color
        }
        return Colors.white.color
    }
    
    public func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        return Colors.black.color
    }
    public func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        changeMonth()
    }
    
    private func changeMonth() {
        let currentPageDate = calendar.currentPage
        let month = Calendar.current.component(.month, from: currentPageDate)
        self.month = month
        self.dateInHome = UDManager.shared.dateInHome![self.month]
        self.dateInSchool = UDManager.shared.dateInSchool![self.month]
        self.calendar.reloadData()
    }
    
    private func moveCurrentPage(moveUp: Bool) {
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.month = moveUp ? 1 : -1
        self.currentPage = calendar.date(byAdding: dateComponents, to: self.currentPage ?? Date())
        self.calendar.setCurrentPage(self.currentPage!, animated: true)
        changeMonth()
    }
}

public extension Date {
    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}
