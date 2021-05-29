//
//  MypageViewModelTests.swift
//  PMS-iOS-V2Tests
//
//  Created by GoEun Jeong on 2021/05/28.
//

import XCTest
import RxCocoa
import RxSwift
import RxFlow
import RxTest
import Moya

@testable import PMS_iOS_V2

class MypageViewModelTests: XCTestCase {
    let disposeBag = DisposeBag()
    
    var viewModel: MypageViewModel!
    var scheduler: TestScheduler!
    
    // MARK: - GIVEN

    override func setUp() {
        let repository = DefaultMypageRepository(provider: MoyaProvider<AuthApi>(stubClosure: { _ in .immediate }))
        viewModel = MypageViewModel(repository: repository)
        scheduler = TestScheduler(initialClock: 0, resolution: 0.01)
    }

    func test_go_login_screen() {
        // MARK: - WHEN
        
        scheduler.createHotObservable([.next(100, ())])
            .bind(to: viewModel.input.outingListButtonTapped)
            .disposed(by: disposeBag)
        
        let observer = scheduler.createObserver(Step.self)
        
        viewModel.steps
            .bind(to: observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        // MARK: - THEN
        
        XCTAssertEqual(observer.events.count, 1)
        XCTAssertEqual(observer.events[0].value.element as! PMSStep,
                       PMSStep.outingListIsRequired)
    }
    
    func test_go_register_screen() {
        // MARK: - WHEN
        
        scheduler.createHotObservable([.next(100, ())])
            .bind(to: viewModel.input.chanegePasswordButtonTapped)
            .disposed(by: disposeBag)
        
        let observer = scheduler.createObserver(Step.self)
        
        viewModel.steps
            .bind(to: observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        // MARK: - THEN
        
        XCTAssertEqual(observer.events.count, 1)
        XCTAssertEqual(observer.events[0].value.element as! PMSStep,
                       PMSStep.changePasswordIsRequired)
    }
}
