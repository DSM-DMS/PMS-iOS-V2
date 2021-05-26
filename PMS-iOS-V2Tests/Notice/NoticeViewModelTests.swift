//
//  NoticeViewModelTests.swift
//  PMS-iOS-V2Tests
//
//  Created by GoEun Jeong on 2021/05/24.
//

import XCTest
import RxCocoa
import RxSwift
import RxTest
import Moya

@testable import PMS_iOS_V2

class NoticeViewModelTests: XCTestCase {
    let disposeBag = DisposeBag()
    
    var view: NoticeViewController!
    var viewModel: NoticeViewModel!
    var scheduler: TestScheduler!
    
    // MARK: - GIVEN
    
    override func setUp() {
        let repository = DefaultNoticeRepository(provider: MoyaProvider<PMSApi>(stubClosure: { _ in .immediate }))
        viewModel = NoticeViewModel(noticeRepository: repository)
        view = NoticeViewController(viewModel: viewModel)
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
    
    func test_viewDidLoad_get_noticeList() {
        // MARK: - WHEN
        
        scheduler.createHotObservable([.next(100, ())])
            .bind(to: viewModel.input.viewDidLoad)
            .disposed(by: disposeBag)
        
        let observer = scheduler.createObserver([NoticeCell].self)
        
        viewModel.output.noticeList
            .bind(to: observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        let exceptEvents: [Recorded<Event<[NoticeCell]>>] = [
            .next(100, Bundle.getNoticeListJson())
        ]
        
        // MARK: - THEN
        
        XCTAssertEqual(observer.events, exceptEvents)
    }
    
    func test_page_one_backButton() {
        // MARK: - WHEN
        
        viewModel.input.viewDidLoad.accept(())
        
        scheduler.createHotObservable([.next(100, ())])
            .bind(to: viewModel.input.previousPageTapped)
            .disposed(by: disposeBag)
        
        let observer = scheduler.createObserver(Int.self)
        
        viewModel.output.page
            .bind(to: observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        let exceptEvents: [Recorded<Event<Int>>] = [
            .next(0, 1)
        ]
        
        // MARK: - THEN
        
        XCTAssertEqual(observer.events, exceptEvents)
    }
    
    func test_page_one_nextButton() {
        // MARK: - WHEN
        
        viewModel.input.viewDidLoad.accept(())
        
        scheduler.createHotObservable([.next(0, ())])
            .bind(to: viewModel.input.previousPageTapped)
            .disposed(by: disposeBag)
        
        scheduler.createHotObservable([.next(50, ()), .next(100, ())])
            .bind(to: viewModel.input.nextPageTapped)
            .disposed(by: disposeBag)
        
        let observer = scheduler.createObserver(Int.self)
        
        viewModel.output.page
            .bind(to: observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        let exceptEvents: [Recorded<Event<Int>>] = [
            .next(0, 1),
            .next(50, 2),
            .next(100, 3)
        ]
        
        // MARK: - THEN
        
        XCTAssertEqual(observer.events, exceptEvents)
    }
}
