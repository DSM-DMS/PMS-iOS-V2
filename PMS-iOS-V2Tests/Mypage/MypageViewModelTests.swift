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
    
    func test_viewDidLoad_get_user() {
        // MARK: - WHEN
        
        scheduler.createHotObservable([.next(100, ())])
            .bind(to: viewModel.input.viewDidLoad)
            .disposed(by: disposeBag)
        
        let observer = scheduler.createObserver(User.self)
        
        viewModel.output.user
            .bind(to: observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        let exceptEvents: [Recorded<Event<User>>] = [
            .next(100, Bundle.getUserJson())
        ]
        
        // MARK: - THEN
        
        XCTAssertEqual(observer.events, exceptEvents)
    }
    
    func test_viewDidLoad_get_student_status() {
        // MARK: - WHEN
        
        scheduler.createHotObservable([.next(100, ())])
            .bind(to: viewModel.input.viewDidLoad)
            .disposed(by: disposeBag)
        
        let observer = scheduler.createObserver(Student.self)
        
        viewModel.output.studentStatus
            .bind(to: observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        let exceptEvents: [Recorded<Event<Student>>] = [
            .next(100, Bundle.getStudentStatusJson())
        ]
        
        // MARK: - THEN
        
        XCTAssertEqual(observer.events, exceptEvents)
    }
    
    func test_go_pointList_screen() {
        // MARK: - WHEN
        
        scheduler.createHotObservable([.next(100, ())])
            .bind(to: viewModel.input.pointListButtonTapped)
            .disposed(by: disposeBag)
        
        let observer = scheduler.createObserver(Step.self)
        
        viewModel.steps
            .bind(to: observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        // MARK: - THEN
        
        XCTAssertEqual(observer.events.count, 1)
        XCTAssertEqual(observer.events[0].value.element as! PMSStep,
                       PMSStep.pointListIsRequired(number: UDManager.shared.studentNumber!))
    }

    func test_go_outingList_screen() {
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
                       PMSStep.outingListIsRequired(number: UDManager.shared.studentNumber!))
    }
    
    func test_go_changePassword_screen() {
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
    
    func test_go_logout_screen() {
        // MARK: - WHEN
        
        scheduler.createHotObservable([.next(100, ())])
            .bind(to: viewModel.input.logoutButtonTapped)
            .disposed(by: disposeBag)
        
        let observer = scheduler.createObserver(Step.self)
        
        viewModel.steps
            .bind(to: observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        // MARK: - THEN
        
        XCTAssertEqual(observer.events.count, 1)
        XCTAssertEqual(observer.events[0].value.element as! PMSStep,
                       PMSStep.logout)
    }
    
    func test_dismiss_tabbar_studentList_screen() {
        // MARK: - WHEN
        
        scheduler.createHotObservable([.next(100, ())])
            .bind(to: viewModel.input.studentListButtonTapped)
            .disposed(by: disposeBag)
        
        let observer = scheduler.createObserver(Step.self)
        
        viewModel.steps
            .bind(to: observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        // MARK: - THEN
        
        XCTAssertEqual(observer.events.count, 1)
        XCTAssertEqual(observer.events[0].value.element as! PMSStep,
                       PMSStep.dismissTabbar)
    }
    
    func test_dismiss_tabbar_nickname_screen() {
        // MARK: - WHEN
        
        scheduler.createHotObservable([.next(100, ())])
            .bind(to: viewModel.input.changeNicknameButtonTapped)
            .disposed(by: disposeBag)
        
        let observer = scheduler.createObserver(Step.self)
        
        viewModel.steps
            .bind(to: observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        // MARK: - THEN
        
        XCTAssertEqual(observer.events.count, 1)
        XCTAssertEqual(observer.events[0].value.element as! PMSStep,
                       PMSStep.dismissTabbar)
    }
    
}
