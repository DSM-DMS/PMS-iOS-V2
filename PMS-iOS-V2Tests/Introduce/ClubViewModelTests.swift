//
//  ClubViewModelTests.swift
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

class ClubViewModelTests: XCTestCase {
    let disposeBag = DisposeBag()
    
    var viewModel: ClubViewModel!
    var scheduler: TestScheduler!
    
    // MARK: - GIVEN
    
    override func setUp() {
        let repository = DefaultIntroduceRepository(provider: MoyaProvider<PMSApi>(stubClosure: { _ in .immediate }))
        viewModel = ClubViewModel(repository: repository)
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
    
    func test_viewDidLoad_get_clubList() {
        // MARK: - WHEN
        
        scheduler.createHotObservable([.next(100, ())])
            .bind(to: viewModel.input.viewDidLoad)
            .disposed(by: disposeBag)
        
        let observer = scheduler.createObserver([Club].self)
        
        viewModel.output.clubList
            .bind(to: observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        let exceptEvents: [Recorded<Event<[Club]>>] = [
            .next(0, []),
            .next(100, Bundle.getClubListJson())
        ]
        
        // MARK: - THEN
        
        XCTAssertEqual(observer.events, exceptEvents)
    }
    
    func test_viewDidLoad_noInternet_alert() {
        // MARK: - WHEN
        viewModel = ClubViewModel(repository: MockFailIntroduceRepository(test: .noInternet))
        
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
    
    func test_imageURL_encoding() {
        // MARK: - WHEN
        
        viewModel.input.viewDidLoad.accept(())
        
        // MARK: - THEN
        
        XCTAssertNotEqual(viewModel.output.clubList.value.first!.imageUrl, "https://api.eungyeol.live/file/club/-1151200003모딥로고2 배경 검정.png")
        XCTAssertEqual(viewModel.output.clubList.value.first!.imageUrl, "https://api.eungyeol.live/file/club/-1151200003%EB%AA%A8%EB%94%A5%EB%A1%9C%EA%B3%A02%20%EB%B0%B0%EA%B2%BD%20%EA%B2%80%EC%A0%95.png")
    }
}
