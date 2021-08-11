//
//  ChangePasswordViewModelTests.swift
//  PMS-iOS-V2Tests
//
//  Created by GoEun Jeong on 2021/05/29.
//

import XCTest
import RxCocoa
import RxSwift
import RxTest
import Moya
import RxFlow

@testable import PMS_iOS_V2

class ChangePasswordViewModelTests: XCTestCase {
    let disposeBag = DisposeBag()
    
    var viewModel: ChangePasswordViewModel!
    var scheduler: TestScheduler!
    
    // MARK: - GIVEN

    override func setUp() {
        let repository = DefaultChangePasswordRepository(provider: MoyaProvider<AuthApi>(stubClosure: { _ in .immediate }))
        viewModel = ChangePasswordViewModel(repository: repository)
        scheduler = TestScheduler(initialClock: 0, resolution: 0.01)
    }
    
    func test_now_password_eye_appear() {
        // MARK: - WHEN
        
        scheduler.createHotObservable([.next(50, "asdf"), .next(100, "")])
            .bind(to: viewModel.input.nowPasswordText)
            .disposed(by: disposeBag)
        
        let observer = scheduler.createObserver(Bool.self)
        
        viewModel.output.nowPasswordEyeVisiable
            .bind(to: observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        let exceptEvents: [Recorded<Event<Bool>>] = [
            .next(0, false),
            .next(50, true),
            .next(100, false)
        ]
        
        // MARK: - THEN
        
        XCTAssertEqual(observer.events, exceptEvents)
    }
    
    func test_new_password_eye_appear() {
        // MARK: - WHEN
        
        scheduler.createHotObservable([.next(50, "asdf"), .next(100, "")])
            .bind(to: viewModel.input.newPasswordText)
            .disposed(by: disposeBag)
        
        let observer = scheduler.createObserver(Bool.self)
        
        viewModel.output.newPasswordEyeVisiable
            .bind(to: observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        let exceptEvents: [Recorded<Event<Bool>>] = [
            .next(0, false),
            .next(50, true),
            .next(100, false)
        ]
        
        // MARK: - THEN
        
        XCTAssertEqual(observer.events, exceptEvents)
    }
    
    func test_newPassword_reNewPassword_notMatch() {
        // MARK: - WHEN
        
        scheduler.createHotObservable([.next(50, "asdf"), .next(100, "a")])
            .bind(to: viewModel.input.newPasswordText)
            .disposed(by: disposeBag)
        
        scheduler.createHotObservable([.next(50, "asdf"), .next(100, "asdf")])
            .bind(to: viewModel.input.reNewPasswordText)
            .disposed(by: disposeBag)
        
        let observer = scheduler.createObserver(String.self)
        
        viewModel.output.isReNewPasswordValidMsg
            .bind(to: observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        let exceptEvents: [Recorded<Event<String>>] = [
            .next(0, ""),
            .next(50, ""),
            .next(100, LocalizedString.notMatchPasswordErrorMsg.localized),
            .next(100, LocalizedString.notMatchPasswordErrorMsg.localized)
        ]
        
        // MARK: - THEN
        
        XCTAssertEqual(observer.events, exceptEvents)
    }
    
    func test_changePasswordButton_inValid() {
        // MARK: - WHEN
        
        scheduler.createHotObservable([.next(50, "asdfasdf")])
            .bind(to: viewModel.input.nowPasswordText)
            .disposed(by: disposeBag)
        
        scheduler.createHotObservable([.next(50, ""), .next(100, "asdf"), .next(150, "asdfasdf")])
            .bind(to: viewModel.input.newPasswordText)
            .disposed(by: disposeBag)
        
        scheduler.createHotObservable([.next(50, ""), .next(100, "asdfasdf"), .next(150, "asdfasdf")])
            .bind(to: viewModel.input.reNewPasswordText)
            .disposed(by: disposeBag)
        
        let observer = scheduler.createObserver(Bool.self)
        
        viewModel.output.changePasswordButtonIsEnable
            .bind(to: observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        let exceptEvents: [Recorded<Event<Bool>>] = [
            .next(0, false),
            .next(50, false),
            .next(50, false),
            .next(100, false),
            .next(150, true),
            .next(150, true)
        ]
        
        // MARK: - THEN
        
        XCTAssertEqual(observer.events, exceptEvents)
    }
    
    func test_change_success_view() {
        // MARK: - WHEN

        scheduler.createHotObservable([.next(100, "success")])
            .bind(to: viewModel.input.nowPasswordText)
            .disposed(by: disposeBag)
        
        scheduler.createHotObservable([.next(100, "success")])
            .bind(to: viewModel.input.newPasswordText)
            .disposed(by: disposeBag)
        
        scheduler.createHotObservable([.next(100, "success")])
            .bind(to: viewModel.input.reNewPasswordText)
            .disposed(by: disposeBag)
        
        scheduler.createHotObservable([.next(100, ())])
            .bind(to: viewModel.input.changePasswordButtonTapped)
            .disposed(by: disposeBag)

        let observer = scheduler.createObserver(Step.self)

        viewModel.steps
            .bind(to: observer)
            .disposed(by: disposeBag)

        scheduler.start()

        // MARK: - THEN

        XCTAssertEqual(observer.events.count, 1)
        XCTAssertEqual(observer.events[0].value.element as? PMSStep,
                       PMSStep.success(.changePasswordSuccessMsg))
    }
    
    func test_now_password_notMatch_alert() {
        // MARK: - WHEN
        viewModel = ChangePasswordViewModel(repository: MockFailChangePasswordRepository(test: .notMatchPassword))
        
        scheduler.createHotObservable([.next(100, "failed")])
            .bind(to: viewModel.input.nowPasswordText)
            .disposed(by: disposeBag)
        
        scheduler.createHotObservable([.next(100, "failed")])
            .bind(to: viewModel.input.newPasswordText)
            .disposed(by: disposeBag)
        
        scheduler.createHotObservable([.next(100, "failed")])
            .bind(to: viewModel.input.reNewPasswordText)
            .disposed(by: disposeBag)
        
        scheduler.createHotObservable([.next(100, ())])
            .bind(to: viewModel.input.changePasswordButtonTapped)
            .disposed(by: disposeBag)
        
        let observer = scheduler.createObserver(Step.self)
        
        viewModel.steps
            .bind(to: observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        // MARK: - THEN
        
        XCTAssertEqual(observer.events.count, 1)
        XCTAssertEqual(observer.events[0].value.element as? PMSStep,
                       PMSStep.alert(LocalizedString.notMatchCurrentPasswordErrorMsg.localized, .notMatchCurrentPasswordErrorMsg))
    }
    
    func test_noInternet_alert() {
        // MARK: - WHEN
        viewModel = ChangePasswordViewModel(repository: MockFailChangePasswordRepository(test: .noInternet))
        
        scheduler.createHotObservable([.next(100, "failed")])
            .bind(to: viewModel.input.nowPasswordText)
            .disposed(by: disposeBag)
        
        scheduler.createHotObservable([.next(100, "failed")])
            .bind(to: viewModel.input.newPasswordText)
            .disposed(by: disposeBag)
        
        scheduler.createHotObservable([.next(100, "failed")])
            .bind(to: viewModel.input.reNewPasswordText)
            .disposed(by: disposeBag)
        
        scheduler.createHotObservable([.next(100, ())])
            .bind(to: viewModel.input.changePasswordButtonTapped)
            .disposed(by: disposeBag)
        
        let observer = scheduler.createObserver(Step.self)
        
        viewModel.steps
            .bind(to: observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        // MARK: - THEN
        
        XCTAssertEqual(observer.events.count, 1)
        XCTAssertEqual(observer.events[0].value.element as? PMSStep,
                       PMSStep.alert(LocalizedString.noInternetErrorMsg.localized, .noInternetErrorMsg))
    }
    
}
