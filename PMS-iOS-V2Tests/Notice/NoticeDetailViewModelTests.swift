//
//  NoticeDetailViewModelTests.swift
//  PMS-iOS-V2Tests
//
//  Created by GoEun Jeong on 2021/05/25.
//

import XCTest
import RxCocoa
import RxSwift
import RxTest
import Moya
import RxFlow

@testable import PMS_iOS_V2

class NoticeDetaiilViewModelTests: XCTestCase {
    let disposeBag = DisposeBag()
    
    var view: NoticeDetailViewController!
    var viewModel: NoticeDetailViewModel!
    var scheduler: TestScheduler!
    
    // MARK: - GIVEN
    
    override func setUp() {
        let repository = DefaultNoticeRepository(provider: MoyaProvider<PMSApi>(stubClosure: { _ in .immediate }))
        viewModel = NoticeDetailViewModel(id: 2, title: "", repository: repository)
        view = NoticeDetailViewController(viewModel: viewModel)
        scheduler = TestScheduler(initialClock: 0, resolution: 0.01)
    }
    
    func test_viewDidLoad_activityIndicator() {
        // MARK: - WHEN
        
        scheduler.createHotObservable([.next(100, ())])
            .bind(to: viewModel.input.viewDidLoad)
            .disposed(by: disposeBag)
        
        let observer = scheduler.createObserver(Bool.self)
        
        viewModel.output.isLoading
            .bind(to: observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        let exceptEvents: [Recorded<Event<Bool>>] = [
            .next(0, false),
            .next(100, true),
            .next(100, false)
        ]
        
        // MARK: - THEN
        
        XCTAssertEqual(observer.events, exceptEvents)
    }
    
    func test_viewDidLoad_get_detailNotice() {
        // MARK: - WHEN
        
        scheduler.createHotObservable([.next(100, ())])
            .bind(to: viewModel.input.viewDidLoad)
            .disposed(by: disposeBag)
        
        let observer = scheduler.createObserver(DetailNotice.self)
        
        viewModel.output.detailNotice
            .bind(to: observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        let exceptEvents: [Recorded<Event<DetailNotice>>] = [
            .next(0, DetailNotice(id: 0, date: "", title: "", body: "", comment: [Comment]())),
            .next(100, Bundle.getDetialNoticeJson())
        ]
        
        // MARK: - THEN
        
        XCTAssertEqual(observer.events, exceptEvents)
    }
    
    func test_viewDidLoad_noInternet_alert() {
        // MARK: - WHEN
        viewModel = NoticeDetailViewModel(id: 2, title: "", repository: MockNoticeRepository(test: .noInternet))
        
        scheduler.createHotObservable([.next(100, ())])
            .bind(to: viewModel.input.viewDidLoad)
            .disposed(by: disposeBag)
        
        let observer = scheduler.createObserver(Step.self)
        
        viewModel.steps
            .bind(to: observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        // MARK: - THEN
        
        XCTAssertEqual(observer.events.count, 1)
        XCTAssertEqual(observer.events[0].value.element as! PMSStep,
                       PMSStep.alert(LocalizedString.noInternetErrorMsg.localized, .noInternetErrorMsg))
    }
}
