//
//  CalendarView.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import UIKit
import FSCalendar
import RxSwift
import RxCocoa
import RxDataSources
import SnapKit

class CalendarViewController: UIViewController {
    let viewModel: CalendarViewModel
    private let tableView = UITableView().then {
        $0.contentMode = .scaleAspectFit
        $0.separatorColor = .clear
        $0.rowHeight = 60.0
    }
    let activityIndicator = UIActivityIndicatorView()
    private let disposeBag = DisposeBag()
    
    private let calendar = FSCalendar().then {
        $0.appearance.selectionColor = Colors.blue.color
        $0.appearance.headerMinimumDissolvedAlpha = 0.0
        $0.today = nil
        $0.appearance.headerDateFormat = LocalizedString.calendarHeaderDateFormat.localized
        $0.appearance.headerTitleColor = Colors.black.color
        $0.appearance.weekdayTextColor = Colors.black.color
//        $0.appearance.caseOptions = .weekdayUsesSingleUpperCase
//        $0.appearance.titleDefaultColor = .white
//        $0.appearance.titlePlaceholderColor = UIColor(hex: 0xC4C4C4)
//        $0.appearance.todayColor = .white
//        $0.appearance.selectionColor = .white
//        $0.allowsMultipleSelection = false
    }
    
    private let dataSource = RxTableViewSectionedReloadDataSource<ListSection<CalendarCell>>(configureCell: {  (_, tableView, _, calendar) -> UITableViewCell in
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarTableViewCell") as? CalendarTableViewCell ?? CalendarTableViewCell(style: .default, reuseIdentifier: "CalendarTableViewCell")
        cell.setupView(model: calendar)
        return cell
    })
    
    private let calendarStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 20.0
    }
    
//    @IBAction func PreviousBtnPressed(_ sender: Any) {
//        self.moveCurrentPage(moveUp: false)
//    }
//
//    @IBAction func NextBtnPressed(_ sender: Any) {
//        self.moveCurrentPage(moveUp: true)
//    }
//
//    private func moveCurrentPage(moveUp: Bool) {
//        let calendar = Calendar.current
//        var dateComponents = DateComponents()
//        dateComponents.month = moveUp ? 1 : -1
//        self.currentPage = calendar.date(byAdding: dateComponents, to: self.currentPage ?? self.today)
//        self.calendar.setCurrentPage(self.currentPage!, animated: true)
//        changeMonth()
//    }
    
    private let dateFormatter = DateFormatter().then {
        $0.dateFormat = "yyyy-MM-dd"
    }
    
    init(viewModel: CalendarViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.bindInput()
        self.calendar.delegate = self
        self.calendar.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.setNavigationTitle(title: .calendarTitle, accessibilityLabel: .calendarTitle, isLarge: true)
        setupSubview()
        bindOutput()
        changeMonth()
    }
    
    private func setupSubview() {
        view.backgroundColor = Colors.white.color
        view.addSubview(calendarStackView)
        view.addSubview(activityIndicator)
        
        calendarStackView.addArrangeSubviews([calendar, tableView])
        
        calendarStackView.snp.makeConstraints {
            $0.top.equalTo(view.snp_topMargin).offset(10)
            $0.center.equalToSuperview()
            $0.width.equalTo(UIFrame.width - 70)
        }
        
        tableView.snp.makeConstraints {
            $0.height.equalTo(UIFrame.height / 5)
        }
        
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func bindInput() {
        self.rx.viewDidLoad
            .bind(to: viewModel.input.viewDidLoad)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput() {
        viewModel.output.reloadData
            .subscribe(onNext: { _ in
                self.calendar.reloadData()
            }).disposed(by: disposeBag)
        
        viewModel.output.isLoading
            .bind(to: activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { self.tableView.deselectRow(at: $0, animated: true)})
            .disposed(by: disposeBag)
        
        viewModel.output.detailCalendar
            .map {
                if $0 == nil {
                    return [ListSection<CalendarCell>(header: "", items: [CalendarCell(label: .calendarPlaceholder)])]
                } else {
                   return [ListSection<CalendarCell>(header: "", items: $0!)]
                }
            }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        self.viewModel.input.date.accept(date)
        
        if viewModel.output.dateInHome.value.contains(viewModel.output.date.value) {
            return Colors.red.color
        }
        
        if viewModel.output.dateInSchool.value.contains(viewModel.output.date.value) {
            return Colors.green.color
        }
        return UIColor.white
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.viewModel.input.date.accept(date)
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        changeMonth()
    }
    
    private func changeMonth() {
        let currentPageDate = calendar.currentPage
        let month = Calendar.current.component(.month, from: currentPageDate)
        Log.info("\(month)")
        self.viewModel.input.month.accept(String(month))
        calendar.reloadData()
    }
}
