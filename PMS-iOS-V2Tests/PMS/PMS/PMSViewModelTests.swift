//
//  PMSViewModelTests.swift
//  PMS-iOS-V2Tests
//
//  Created by GoEun Jeong on 2021/05/26.
//

import XCTest
import RxCocoa
import RxSwift
import RxFlow
import RxTest

@testable import PMS_iOS_V2

class PMSViewModelTests: XCTestCase {
    let disposeBag = DisposeBag()
    
    var viewModel: PMSViewModel!
    var scheduler: TestScheduler!
    
    // MARK: - GIVEN

    override func setUp() {
        viewModel = PMSViewModel()
        scheduler = TestScheduler(initialClock: 0, resolution: 0.01)
    }

    func test_go_login_screen() {
        // MARK: - WHEN
        
        scheduler.createHotObservable([.next(100, ())])
            .bind(to: viewModel.input.loginButtonTapped)
            .disposed(by: disposeBag)
        
        let observer = scheduler.createObserver(Step.self)
        
        viewModel.steps
            .bind(to: observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        // MARK: - THEN
        
        XCTAssertEqual(observer.events.count, 1)
        XCTAssertEqual(observer.events[0].value.element as! PMSStep,
                       PMSStep.loginIsRequired)
    }
    
    func test_go_register_screen() {
        // MARK: - WHEN
        
        scheduler.createHotObservable([.next(100, ())])
            .bind(to: viewModel.input.registerButtonTapped)
            .disposed(by: disposeBag)
        
        let observer = scheduler.createObserver(Step.self)
        
        viewModel.steps
            .bind(to: observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        // MARK: - THEN
        
        XCTAssertEqual(observer.events.count, 1)
        XCTAssertEqual(observer.events[0].value.element as! PMSStep,
                       PMSStep.registerIsRequired)
    }
}
