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
    private let repository: MealRepository
    private let disposeBag = DisposeBag()
    private var changeDate = 0
    
    let viewDateFormatter = DateFormatter().then {
        $0.dateFormat = "yyyy-MM-dd"
    }
    
    struct Input {
        let viewDidLoad = PublishRelay<Void>()
        let previousButtonTapped = PublishRelay<Void>()
        let nextButtonTapped = PublishRelay<Void>()
        let date = BehaviorRelay<Date>(value: Date())
        let getMeal = PublishRelay<Void>()
        let getMealPicture = PublishRelay<Void>()
        let getMealCell = PublishRelay<Void>()
    }
    
    struct Output {
        let modelDate = BehaviorRelay<String>(value: DateFormatter().then {
            $0.dateFormat = "yyyyMMdd"
        }.string(from: Date()))
        let viewDate = BehaviorRelay<String>(value: DateFormatter().then {
            $0.dateFormat = "yyyy-MM-dd"
        }.string(from: Date()))
        let isLoading = BehaviorRelay<Bool>(value: false)
        let mealList = BehaviorRelay<Meal>(value: Meal(breakfast: [String](), lunch: [String](), dinner: [String]()))
        let mealPictureList = BehaviorRelay<MealPicture>(value: MealPicture(breakfast: "", lunch: "", dinner: ""))
        let mealCellList = BehaviorRelay<[MealCell]>(value: .init())
    }
    
    let input = Input()
    let output = Output()
    
    init(repository: MealRepository) {
        self.repository = repository
        let activityIndicator = ActivityIndicator()
        
        input.viewDidLoad
            .bind(to: input.getMeal)
            .disposed(by: disposeBag)
        
        input.viewDidLoad
            .bind(to: input.getMealPicture)
            .disposed(by: disposeBag)
        
        input.getMeal
            .flatMap {
                repository.getMeal(date: Int(self.output.modelDate.value)!)
                    .asObservable()
                    .trackActivity(activityIndicator)
                    .do(onError: { error in
                        let error = error as! NetworkError
                        self.steps.accept(PMSStep.alert(self.mapError(error: error.rawValue), self.mapError(error: error.rawValue)))
                    }).catchErrorJustReturn(Meal(breakfast: [String](), lunch: [String](), dinner: [String]()))
            }
            .bind(to: output.mealList)
            .disposed(by: disposeBag)
        
        input.getMealPicture
            .flatMap {
                repository.getMealPicutre(date: Int(self.output.modelDate.value)!)
                    .asObservable()
            }
            .bind(to: output.mealPictureList)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(
            self.output.mealList.asObservable(),
            self.output.mealPictureList.distinctUntilChanged().asObservable()
        ) { (meal, picture) -> [MealCell] in
            var mealList = [MealCell]()
            mealList.append(MealCell(time: .breakfast, meal: meal.breakfast, imageURL: picture.breakfast))
            mealList.append(MealCell(time: .lunch, meal: meal.lunch, imageURL: picture.lunch))
            mealList.append(MealCell(time: .dinner, meal: meal.dinner, imageURL: picture.dinner))
            return mealList
        }
        .catchErrorJustReturn([])
        .do(onError: { error in
            let error = error as! NetworkError
            self.steps.accept(PMSStep.alert(self.mapError(error: error.rawValue), self.mapError(error: error.rawValue)))
        })
        .bind(to: output.mealCellList)
        .disposed(by: disposeBag)
        
        input.previousButtonTapped
            .asObservable()
            .map { self.changeDate -= 1}
            .subscribe(onNext: { _ in self.setDate() })
            .disposed(by: disposeBag)
        
        input.nextButtonTapped
            .asObservable()
            .map { self.changeDate += 1}
            .subscribe(onNext: { _ in self.setDate() })
            .disposed(by: disposeBag)
        
        output.modelDate
            .map { _ in }
            .bind(to: input.getMeal)
            .disposed(by: disposeBag)
        
        output.modelDate
            .map { _ in }
            .bind(to: input.getMealPicture)
            .disposed(by: disposeBag)
        
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
    
    private func setDate() {
        let date = Date()
        
        var dateComponent = DateComponents()
        dateComponent.day = self.changeDate
        let futureDate = Calendar.current.date(byAdding: dateComponent, to: date)
        
        var formattedDate = self.viewDateFormatter.string(from: futureDate!)
        self.output.viewDate.accept(formattedDate)
        formattedDate = formattedDate.replacingOccurrences(of: "-", with: "")
        self.output.modelDate.accept(formattedDate)
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
