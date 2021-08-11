//
//  LoginViewModelTests.swift
//  PMS-iOS-V2Tests
//
//  Created by GoEun Jeong on 2021/05/20.
//

import XCTest
import RxCocoa
import RxSwift
import RxTest
import Moya
import RxFlow

@testable import PMS_iOS_V2

class LoginViewModelTests: XCTestCase {
    let disposeBag = DisposeBag()
    
    var viewModel: LoginViewModel!
    var scheduler: TestScheduler!
    
    // MARK: - GIVEN

    override func setUp() {
        let repository = DefaultLoginRepository(provider: MoyaProvider<AuthApi>(stubClosure: { _ in .immediate }))
        viewModel = LoginViewModel(repository: repository)
        scheduler = TestScheduler(initialClock: 0, resolution: 0.01)
    }

    func test_email_inValid() {
        
        // MARK: - WHEN
        
        scheduler.createHotObservable([.next(50, "asdf"), .next(100, "asdf@asdf.com")])
            .bind(to: viewModel.input.emailText)
            .disposed(by: disposeBag)
        
        let observer = scheduler.createObserver(Bool.self)
        
        viewModel.output.isEmailValid
            .bind(to: observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        let exceptEvents: [Recorded<Event<Bool>>] = [
            .next(0, false),
            .next(50, false),
            .next(100, true)
        ]
        
        // MARK: - THEN
        
        XCTAssertEqual(observer.events, exceptEvents)
        XCTAssertEqual(viewModel.output.loginButtonIsEnable.value, false)
    }
    
    func test_password_eye_appear() {
        // MARK: - WHEN
        
        scheduler.createHotObservable([.next(50, "asdf"), .next(100, "")])
            .bind(to: viewModel.input.passwordText)
            .disposed(by: disposeBag)
        
        let observer = scheduler.createObserver(Bool.self)
        
        viewModel.output.passwordEyeVisiable
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
    
    func test_loginButton_inValid() {
        // MARK: - WHEN
        
        scheduler.createHotObservable([.next(50, "asdf"), .next(100, "asdf@asdf.com")])
            .bind(to: viewModel.input.emailText)
            .disposed(by: disposeBag)
        
        scheduler.createHotObservable([.next(50, ""), .next(100, "asdf"), .next(150, "")])
            .bind(to: viewModel.input.passwordText)
            .disposed(by: disposeBag)
        
        let observer = scheduler.createObserver(Bool.self)
        
        viewModel.output.loginButtonIsEnable
            .bind(to: observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        let exceptEvents: [Recorded<Event<Bool>>] = [
            .next(0, false),
            .next(50, false),
            .next(100, false),
            .next(100, true),
            .next(150, false)
        ]
        
        // MARK: - THEN
        
        XCTAssertEqual(observer.events, exceptEvents)
    }
    
    func test_login_success_view() {
        // MARK: - WHEN
        
        scheduler.createHotObservable([.next(100, "login@.")])
            .bind(to: viewModel.input.emailText)
            .disposed(by: disposeBag)
        
        scheduler.createHotObservable([.next(100, "success")])
            .bind(to: viewModel.input.passwordText)
            .disposed(by: disposeBag)
        
        scheduler.createHotObservable([.next(100, ())])
            .bind(to: viewModel.input.loginButtonTapped)
            .disposed(by: disposeBag)
        
        let observer = scheduler.createObserver(Step.self)
        
        viewModel.steps
            .bind(to: observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        // MARK: - THEN
        
        XCTAssertEqual(observer.events.count, 2)
        XCTAssertEqual(observer.events[0].value.element as? PMSStep,
                       PMSStep.success(.loginSuccessMsg))
    }
    
    func test_login_existUser_alert() {
        // MARK: - WHEN
        viewModel = LoginViewModel(repository: MockFailLoginRepository(test: .notFoundUser))
        
        scheduler.createHotObservable([.next(100, "login@.")])
            .bind(to: viewModel.input.emailText)
            .disposed(by: disposeBag)
        
        scheduler.createHotObservable([.next(100, "failed")])
            .bind(to: viewModel.input.passwordText)
            .disposed(by: disposeBag)
        
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
        XCTAssertEqual(observer.events[0].value.element as? PMSStep,
                       PMSStep.alert(LocalizedString.notFoundUserErrorMsg.localized, .notFoundUserErrorMsg))
    }
    
    func test_login_noInternet_alert() {
        // MARK: - WHEN
        viewModel = LoginViewModel(repository: MockFailLoginRepository(test: .noInternet))
        
        scheduler.createHotObservable([.next(100, "login@.")])
            .bind(to: viewModel.input.emailText)
            .disposed(by: disposeBag)
        
        scheduler.createHotObservable([.next(100, "failed")])
            .bind(to: viewModel.input.passwordText)
            .disposed(by: disposeBag)
        
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
        XCTAssertEqual(observer.events[0].value.element as? PMSStep,
                       PMSStep.alert(LocalizedString.noInternetErrorMsg.localized, .noInternetErrorMsg))
    }
    
}
