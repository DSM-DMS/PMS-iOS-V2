//
//  RegisterViewModelTests.swift
//  PMS-iOS-V2Tests
//
//  Created by GoEun Jeong on 2021/05/21.
//

import XCTest
import RxCocoa
import RxSwift
import RxTest
import Moya
import RxFlow

@testable import PMS_iOS_V2

class RegisterViewModelTests: XCTestCase {
    let disposeBag = DisposeBag()
    
    var viewModel: RegisterViewModel!
    var scheduler: TestScheduler!
    
    // MARK: - GIVEN

    override func setUp() {
        let repository = DefaultRegisterRepository(provider: MoyaProvider<AuthApi>(stubClosure: { _ in .immediate }))
        viewModel = RegisterViewModel(repository: repository)
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
        XCTAssertEqual(viewModel.output.registerButtonIsEnable.value, false)
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
    
    func test_password_rePassword_notMatch() {
        // MARK: - WHEN
        
        scheduler.createHotObservable([.next(50, "asdf"), .next(100, "a")])
            .bind(to: viewModel.input.passwordText)
            .disposed(by: disposeBag)
        
        scheduler.createHotObservable([.next(50, "asdf"), .next(100, "asdf")])
            .bind(to: viewModel.input.rePasswordText)
            .disposed(by: disposeBag)
        
        let observer = scheduler.createObserver(String.self)
        
        viewModel.output.isRePasswordValidMsg
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
    
    func test_registerButton_inValid() {
        // MARK: - WHEN
        
        scheduler.createHotObservable([.next(50, ""), .next(100, "nickname")])
            .bind(to: viewModel.input.nicknameText)
            .disposed(by: disposeBag)
        
        scheduler.createHotObservable([.next(50, "asdf"), .next(100, "asdf@asdf.com")])
            .bind(to: viewModel.input.emailText)
            .disposed(by: disposeBag)
        
        scheduler.createHotObservable([.next(50, ""), .next(100, "asdf"), .next(150, "asdfasdf")])
            .bind(to: viewModel.input.passwordText)
            .disposed(by: disposeBag)
        
        scheduler.createHotObservable([.next(50, ""), .next(100, "asdfasdf"), .next(150, "asdfasdf")])
            .bind(to: viewModel.input.rePasswordText)
            .disposed(by: disposeBag)
        
        let observer = scheduler.createObserver(Bool.self)
        
        viewModel.output.registerButtonIsEnable
            .bind(to: observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        let exceptEvents: [Recorded<Event<Bool>>] = [
            .next(0, false),
            .next(50, false),
            .next(50, false),
            .next(100, false),
            .next(100, false),
            .next(100, false),
            .next(100, false),
            .next(100, false),
            .next(150, false),
            .next(150, true),
            .next(150, true)
        ]
        
        // MARK: - THEN
        
        XCTAssertEqual(observer.events, exceptEvents)
    }
    
    func test_login_success_view() {
        // MARK: - WHEN
        
        scheduler.createHotObservable([.next(100, ".")])
            .bind(to: viewModel.input.nicknameText)
            .disposed(by: disposeBag)
        
        scheduler.createHotObservable([.next(100, "login@.")])
            .bind(to: viewModel.input.emailText)
            .disposed(by: disposeBag)
        
        scheduler.createHotObservable([.next(100, "success")])
            .bind(to: viewModel.input.passwordText)
            .disposed(by: disposeBag)
        
        scheduler.createHotObservable([.next(100, "success")])
            .bind(to: viewModel.input.rePasswordText)
            .disposed(by: disposeBag)
        
        scheduler.createHotObservable([.next(100, ())])
            .bind(to: viewModel.input.registerButtonTapped)
            .disposed(by: disposeBag)
        
        let observer = scheduler.createObserver(Step.self)
        
        viewModel.steps
            .bind(to: observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        // MARK: - THEN
        
        XCTAssertEqual(observer.events.count, 2)
        XCTAssertEqual(observer.events[0].value.element as! PMSStep,
                       PMSStep.success(.registerSuccessMsg))
    }
    
    func test_login_notMatch_alert() {
        // MARK: - WHEN
        viewModel = RegisterViewModel(repository: MockFailRegisterRepository(test: .existUser))
        
        scheduler.createHotObservable([.next(100, ".")])
            .bind(to: viewModel.input.nicknameText)
            .disposed(by: disposeBag)
        
        scheduler.createHotObservable([.next(100, "login@.")])
            .bind(to: viewModel.input.emailText)
            .disposed(by: disposeBag)
        
        scheduler.createHotObservable([.next(100, "failed")])
            .bind(to: viewModel.input.passwordText)
            .disposed(by: disposeBag)
        
        scheduler.createHotObservable([.next(100, "failed")])
            .bind(to: viewModel.input.rePasswordText)
            .disposed(by: disposeBag)
        
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
                       PMSStep.alert(LocalizedString.existUserErrorMsg.localized, .existUserErrorMsg))
    }
    
    func test_login_noInternet_alert() {
        // MARK: - WHEN
        viewModel = RegisterViewModel(repository: MockFailRegisterRepository(test: .noInternet))
        
        scheduler.createHotObservable([.next(100, ".")])
            .bind(to: viewModel.input.nicknameText)
            .disposed(by: disposeBag)
        
        scheduler.createHotObservable([.next(100, "login@.")])
            .bind(to: viewModel.input.emailText)
            .disposed(by: disposeBag)
        
        scheduler.createHotObservable([.next(100, "failed")])
            .bind(to: viewModel.input.passwordText)
            .disposed(by: disposeBag)
        
        scheduler.createHotObservable([.next(100, "failed")])
            .bind(to: viewModel.input.rePasswordText)
            .disposed(by: disposeBag)
        
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
                       PMSStep.alert(LocalizedString.noInternetErrorMsg.localized, .noInternetErrorMsg))
    }
    
}
