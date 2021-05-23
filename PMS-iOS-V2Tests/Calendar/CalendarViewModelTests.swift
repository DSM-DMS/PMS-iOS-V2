//
//  CalendarViewModelTests.swift
//  PMS-iOS-V2Tests
//
//  Created by GoEun Jeong on 2021/05/23.
//

import XCTest
import RxCocoa
import RxSwift
import RxTest
import Moya
import RxFlow

@testable import PMS_iOS_V2

class CalenddarViewModelTests: XCTestCase {
    let disposeBag = DisposeBag()
    
    var viewModel: CalendarViewModel!
    var scheduler: TestScheduler!
    
    // MARK: - GIVEN

    override func setUp() {
        let repository = DefaultCalendarRepository(provider: MoyaProvider<PMSApi>(stubClosure: { _ in .immediate }))
        viewModel = CalendarViewModel(calendarRepository: repository)
        scheduler = TestScheduler(initialClock: 0, resolution: 0.01)
    }
    
    func test_viewDidLoad_calendar() {
        // MARK: - WHEN
        
        scheduler.createHotObservable([.next(100, ())])
            .bind(to: viewModel.input.viewDidLoad)
            .disposed(by: disposeBag)
        
        let observer = scheduler.createObserver(PMSCalendar.self)
        
        viewModel.output.calendar
            .bind(to: observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        let exceptEvents: [Recorded<Event<PMSCalendar>>] = [
            .next(100, Bundle.getCalendarJson())
        ]
        
        // MARK: - THEN
        
        XCTAssertEqual(observer.events, exceptEvents)
    }
    
    func test_selectDate_exist_calendar() {
        // MARK: - WHEN
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let date = formatter.date(from: "2021/08/15")
        
        scheduler.createHotObservable([.next(100, date!)])
            .bind(to: viewModel.input.date)
            .disposed(by: disposeBag)
        
        let observer = scheduler.createObserver([String].self)
        
        viewModel.output.detailCalendar
            .bind(to: observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        let exceptEvents: [Recorded<Event<[String]>>] = [
            .next(100, ["광복절"])
        ]
        
        // MARK: - THEN
        
        XCTAssertEqual(observer.events, exceptEvents)
    }
    
    func test_selectDate_none_calendar() {
        // MARK: - WHEN
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let date = formatter.date(from: "2021/08/16")
        
        scheduler.createHotObservable([.next(100, date!)])
            .bind(to: viewModel.input.date)
            .disposed(by: disposeBag)
        
        let observer = scheduler.createObserver([String].self)
        
        viewModel.output.detailCalendar
            .bind(to: observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        let exceptEvents: [Recorded<Event<[String]>>] = [
            .next(100, [""])
        ]
        
        // MARK: - THEN
        
        XCTAssertEqual(observer.events, exceptEvents)
    }
}
