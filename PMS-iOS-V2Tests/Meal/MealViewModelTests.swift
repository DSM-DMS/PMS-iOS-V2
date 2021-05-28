//
//  MealViewModelTests.swift
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

class MealViewModelTests: XCTestCase {
    let disposeBag = DisposeBag()
    
    var view: MealViewController!
    var viewModel: MealViewModel!
    var scheduler: TestScheduler!
    var changeDate = 0
    
    let dateFormatter = DateFormatter().then {
        $0.dateFormat = "yyyy-MM-dd"
    }
    
    // MARK: - GIVEN
    
    override func setUp() {
        let repository = DefaultMealRepository(provider: MoyaProvider<PMSApi>(stubClosure: { _ in .immediate }))
        viewModel = MealViewModel(repository: repository)
        view = MealViewController(viewModel: viewModel)
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
    
    func test_viewDidLoad_mealCellList() {
        // MARK: - WHEN
        
        scheduler.createHotObservable([.next(100, ())])
            .bind(to: viewModel.input.viewDidLoad)
            .disposed(by: disposeBag)
        
        let observer = scheduler.createObserver([MealCell].self)
        
        viewModel.output.mealCellList
            .bind(to: observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        let exceptEvents: [Recorded<Event<[MealCell]>>] = [
            .next(0, [MealCell(time: .breakfast, meal: ["아침"], imageURL: ""),
                        MealCell(time: .lunch, meal: ["점심"], imageURL: ""),
                        MealCell(time: .dinner, meal: ["저녁"], imageURL: "")]),
            .next(100, [MealCell(time: .breakfast, meal: ["아침"], imageURL: ""),
                        MealCell(time: .lunch, meal: ["점심"], imageURL: ""),
                        MealCell(time: .dinner, meal: ["저녁"], imageURL: "")])
        ]
        
        // MARK: - THEN
        XCTAssertEqual(observer.events, exceptEvents)
    }
    
    func test_changeDate_previous() {
        // MARK: - WHEN
        view.viewDidLoad()
        
        viewModel.input.previousButtonTapped.accept(())
        // MARK: - THEN
        
        XCTAssertEqual(viewModel.output.viewDate.value, getDate(increase: false))
        XCTAssertEqual(view.dateLabel.text, getDate())
        viewModel.input.nextButtonTapped.accept(())
        self.getDate(increase: true)
        viewModel.input.nextButtonTapped.accept(())
        XCTAssertEqual(viewModel.output.viewDate.value, getDate(increase: true))
        XCTAssertEqual(view.dateLabel.text, getDate())
    }
    
    private func getDate(increase: Bool) -> String {
        let date = Date()
        
        if increase { self.changeDate += 1 } else { self.changeDate -= 1 }
        
        var dateComponent = DateComponents()
        dateComponent.day = self.changeDate
        let futureDate = Calendar.current.date(byAdding: dateComponent, to: date)
        
        return self.dateFormatter.string(from: futureDate!)
    }
    
    private func getDate() -> String {
        let date = Date()
        
        var dateComponent = DateComponents()
        dateComponent.day = self.changeDate
        let futureDate = Calendar.current.date(byAdding: dateComponent, to: date)
        
        return self.dateFormatter.string(from: futureDate!)
    }
}
