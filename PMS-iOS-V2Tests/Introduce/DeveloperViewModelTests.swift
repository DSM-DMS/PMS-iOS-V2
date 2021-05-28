//
//  DeveloperViewModelTests.swift
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

class DevleoperViewModelTests: XCTestCase {
    let disposeBag = DisposeBag()
    
    var viewModel: DeveloperViewModel!
    var scheduler: TestScheduler!
    
    // MARK: - GIVEN
    
    override func setUp() {
        let repository = DefaultIntroduceRepository(provider: MoyaProvider<PMSApi>(stubClosure: { _ in .immediate }))
        viewModel = DeveloperViewModel(repository: repository)
        scheduler = TestScheduler(initialClock: 0, resolution: 0.01)
    }
    
    func test_viewDidLoad_get_developerList() {
        // MARK: - WHEN
        
        scheduler.createHotObservable([.next(100, ())])
            .bind(to: viewModel.input.viewDidLoad)
            .disposed(by: disposeBag)
        
        let observer = scheduler.createObserver([Developer].self)
        
        viewModel.output.developerList
            .bind(to: observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        let exceptEvents: [Recorded<Event<[Developer]>>] = [
            .next(100, Bundle.getDevelopers())
        ]
        
        // MARK: - THEN
        
        XCTAssertEqual(observer.events, exceptEvents)
    }
}
