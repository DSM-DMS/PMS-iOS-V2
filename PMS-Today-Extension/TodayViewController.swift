//
//  TodayViewController.swift
//  PMS-Today-Extension
//
//  Created by GoEun Jeong on 2021/08/19.
//

import UIKit
import NotificationCenter
import FSCalendar
import SnapKit
import Then

@objc(TodayViewController)
final public class TodayViewController: UIViewController, NCWidgetProviding {
    
    private let calendar = FSCalendar().then {
        $0.appearance.selectionColor = Colors.blue.color
        $0.appearance.headerMinimumDissolvedAlpha = 0.0
        $0.today = nil
//        $0.appearance.headerDateFormat = LocalizedString.calendarHeaderDateFormat.localized
        $0.appearance.headerTitleColor = UIColor.black
        $0.appearance.weekdayTextColor = UIColor.black
        $0.placeholderType = .none
        let localeID = Locale.preferredLanguages.first
        let deviceLocale = (Locale(identifier: localeID!).languageCode)!
        $0.locale = Locale(identifier: deviceLocale)
        $0.appearance.titleFont = UIFont.preferredFont(forTextStyle: .callout)
        $0.appearance.weekdayFont = UIFont.preferredFont(forTextStyle: .callout)
        $0.appearance.subtitleFont = UIFont.preferredFont(forTextStyle: .callout)
        $0.appearance.headerTitleFont = UIFont.preferredFont(forTextStyle: .callout)
    }
    
    private var dateInHome = [String]()
    private var dateInSchool = [String]()
    private var month = Date().get(.month)
    private var currentPage: Date?
    
    private let dateFormatter = DateFormatter()

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        view.addSubview(calendar)
        self.setupView()
        self.intializeCalendar()
    }
    
    private func setupView() {
        calendar.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.height.equalTo(300)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
    }
    
    private func intializeCalendar() {
        calendar.delegate = self
        calendar.dataSource = self
        
        if  UserDefaults.shared.object(forKey: "PMSCalendar") != nil {
            let dateInHome = UserDefaults.shared.object(forKey: "dateInHome") as! [[String]]
            let dateInSchool = UserDefaults.shared.object(forKey: "dateInSchool") as! [[String]]
            self.dateInHome = dateInHome[self.month]
            self.dateInSchool = dateInSchool[self.month]
            self.calendar.reloadData()
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
        
        if activeDisplayMode == .expanded {
            self.calendar.scope = .month
        } else {
            self.calendar.scope = .week
        }
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
        return UIColor.clear
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
        
        if UserDefaults.shared.object(forKey: "dateInHome") != nil {
            let dateInHome = UserDefaults.shared.object(forKey: "dateInHome") as! [[String]]
            let dateInSchool = UserDefaults.shared.object(forKey: "dateInSchool") as! [[String]]
            self.dateInHome = dateInHome[self.month]
            self.dateInSchool = dateInSchool[self.month]
            self.calendar.reloadData()
        }
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
