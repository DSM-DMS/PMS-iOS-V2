//
//  IntroduceViewModelTests.swift
//  PMS-iOS-V2Tests
//
//  Created by GoEun Jeong on 2021/05/27.
//

import XCTest
import RxCocoa
import RxSwift
import RxTest
import RxFlow
import Moya

@testable import PMS_iOS_V2

class IntroduceViewModelTests: XCTestCase {
    let disposeBag = DisposeBag()
    
    var viewModel: IntroduceViewModel!
    var scheduler: TestScheduler!
    
    // MARK: - GIVEN
    
    override func setUp() {
        viewModel = IntroduceViewModel()
        scheduler = TestScheduler(initialClock: 0, resolution: 0.01)
    }
    
    func test_go_club_screen() {
        // MARK: - WHEN
        
        scheduler.createHotObservable([.next(100, ())])
            .bind(to: viewModel.input.clubButtonTapped)
            .disposed(by: disposeBag)
        
        let observer = scheduler.createObserver(Step.self)
        
        viewModel.steps
            .bind(to: observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        // MARK: - THEN
        
        XCTAssertEqual(observer.events.count, 1)
        XCTAssertEqual(observer.events[0].value.element as! PMSStep,
                       PMSStep.clubIsRequired)
    }
    
    func test_go_company_screen() {
        // MARK: - WHEN
        
        scheduler.createHotObservable([.next(100, ())])
            .bind(to: viewModel.input.developerButtonTapped)
            .disposed(by: disposeBag)
        
        let observer = scheduler.createObserver(Step.self)
        
        viewModel.steps
            .bind(to: observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        // MARK: - THEN
        
        XCTAssertEqual(observer.events.count, 1)
        XCTAssertEqual(observer.events[0].value.element as! PMSStep,
                       PMSStep.developerIsRequired)
    }
    
    func test_go_developer_screen() {
        // MARK: - WHEN
        
        scheduler.createHotObservable([.next(100, ())])
            .bind(to: viewModel.input.companyButtonTapped)
            .disposed(by: disposeBag)
        
        let observer = scheduler.createObserver(Step.self)
        
        viewModel.steps
            .bind(to: observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        // MARK: - THEN
        
        XCTAssertEqual(observer.events.count, 1)
        XCTAssertEqual(observer.events[0].value.element as! PMSStep,
                       PMSStep.companyIsRequired)
    }
    
}
