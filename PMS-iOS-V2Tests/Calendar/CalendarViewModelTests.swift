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
            .next(0, [:]),
            .next(100, Bundle.getCalendarJson())
        ]
        
        // MARK: - THEN
        
        XCTAssertEqual(observer.events, exceptEvents)
    }
    
    func test_selectDate_exist_calendar() {
        // MARK: - WHEN
        viewModel.input.viewDidLoad.accept(())
        viewModel.input.month.accept("8")
        scheduler.createHotObservable([.next(100, "2021-08-15")])
            .bind(to: viewModel.output.selectedDate)
            .disposed(by: disposeBag)
        
        let observer = scheduler.createObserver([CalendarCell]?.self)
        
        viewModel.output.detailCalendar
            .bind(to: observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        let exceptEvents: [Recorded<Event<[CalendarCell]?>>] = [
            .next(0, nil),
            .next(100, [CalendarCell(date: "08 / 15", event: "광복절", isHome: false)])
        ]
        
        // MARK: - THEN
        
        XCTAssertEqual(observer.events, exceptEvents)
    }
    
    func test_selectDate_none_calendar() {
        // MARK: - WHEN
        viewModel.input.viewDidLoad.accept(())

        scheduler.createHotObservable([.next(100, Date())])
            .bind(to: viewModel.input.selectedDate)
            .disposed(by: disposeBag)
        
        let observer = scheduler.createObserver([CalendarCell]?.self)
        
        viewModel.output.detailCalendar
            .bind(to: observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        let exceptEvents: [Recorded<Event<[CalendarCell]?>>] = [
            .next(0, nil),
            .next(100, [CalendarCell(label: .noEventPlaceholder)])
        ]

        // MARK: - THEN

        XCTAssertEqual(observer.events, exceptEvents)
    }
    
    func test_changeMonth_get_events() {
        // MARK: - WHEN
        viewModel.input.viewDidLoad.accept(())

        scheduler.createHotObservable([.next(100, "8")])
            .bind(to: viewModel.input.month)
            .disposed(by: disposeBag)

        let observer = scheduler.createObserver([String].self)
        
        viewModel.output.dateInSchool
            .bind(to: observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        let exceptEvents: [Recorded<Event<[String]>>] = [
            .next(0, ["2021-05-03", "2021-05-04", "2021-05-05", "2021-05-07", "2021-05-19", "2021-05-27"]), // 현재 5월 테스트 기준 데이터입니다.
            .next(100, ["2021-08-15", "2021-08-16"])
        ]

        // MARK: - THEN

        XCTAssertEqual(observer.events, exceptEvents)
    }
    
    func test_login_noInternet_alert() {
        // MARK: - WHEN
        viewModel = CalendarViewModel(calendarRepository: MockFailCalendarRepository(test: .noInternet))
        
        viewModel.input.viewDidLoad.accept(())
        
        let observer = scheduler.createObserver(Step.self)
        
        viewModel.steps
            .bind(to: observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        // MARK: - THEN
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(observer.events.count, 1)
            XCTAssertEqual(observer.events[0].value.element as! PMSStep,
                           PMSStep.alert(LocalizedString.noInternetErrorMsg.localized, .noInternetErrorMsg))
        }
    }
}
