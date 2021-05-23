//
//  MealViewModel.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import RxSwift
import RxCocoa
import RxFlow

class MealViewModel: Stepper {
    let steps = PublishRelay<Step>()
    let mealRepository: MealRepository
    private var disposeBag = DisposeBag()
    let modelDateFormatter = DateFormatter().then {
        $0.dateFormat = "yyyyMMdd"
    }
    let viewDateFormatter = DateFormatter().then {
        $0.dateFormat = "yyyy-MM-dd"
    }
    
    struct Input {
        let viewDidLoad = PublishRelay<Void>()
        let isLoading = BehaviorRelay<Bool>(value: false)
        let date = BehaviorRelay<Date>(value: Date())
    }
    
    struct Output {
//        let modelDate = BehaviorRelay<Int>(value: Int(DateFormatter().then {
//            $0.dateFormat = "yyyyMMdd"
//        }.date(from: Date().toString())!.toString())!)
        let viewDate = BehaviorRelay<Date>(value: Date())
        let isLoading = BehaviorRelay<Bool>(value: false)
        let mealList = BehaviorRelay<[MealCell]>(value: .init())
    }
    
    let input = Input()
    let output = Output()
    
    init(mealRepository: MealRepository) {
        self.mealRepository = mealRepository
        let activityIndicator = ActivityIndicator()
        
//        input.viewDidLoad
//            .flatMap {
//                mealRepository.getMeal(date: self.output.modelDate.value)
//                    .trackActivity(activityIndicator)
//                    .map { meal -> [MealCell] in
//                        var mealList = [MealCell]()
//                        mealList.append(MealCell(time: .breakfast, meal: meal.breakfast))
//                        mealList.append(MealCell(time: .lunch, meal: meal.lunch))
//                        mealList.append(MealCell(time: .dinner, meal: meal.dinner))
//                        return mealList
//                    }
//                    .do(onError: { error in
//                        let error = error as! NetworkError
//                        self.steps.accept(PMSStep.alert(self.mapError(error: error.rawValue), self.mapError(error: error.rawValue)))
//                        
//                    })
//                    .catchErrorJustReturn([])
//            }.bind(to: output.mealList)
//            .disposed(by: disposeBag)
        
        activityIndicator
            .asObservable()
            .bind(to: output.isLoading)
            .disposed(by: disposeBag)
    }
    
    private func mapError(error: Int) -> String {
        if error == 1 {
            return LocalizedString.noInternetErrorMsg.localized
        } else if error == 401 {
            Log.info("Token Refresh wasn't complete")
            return "내부 로직 오류"
        } else {
            return LocalizedString.unknownErrorMsg.localized
        }
    }
    
    private func mapError(error: Int) -> AccessibilityString {
        if error == 1 {
            return .noInternetErrorMsg
        } else if error == 401 {
            Log.info("Token Refresh wasn't complete")
            return .unknownErrorMsg
        } else {
            return .unknownErrorMsg
        }
    }
}
