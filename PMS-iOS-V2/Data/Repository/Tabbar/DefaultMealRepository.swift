//
//  DefaultMealRepository.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import Moya
import RxSwift

final public class DefaultMealRepository: MealRepository {
    private let provider: MoyaProvider<PMSApi>
    
    public init(provider: MoyaProvider<PMSApi>?) {
        self.provider = provider ?? MoyaProvider<PMSApi>()
    }
    
    public func getMeal(date: Int) -> Single<Meal> {
        provider.rx.request(.meal(date))
            .filterSuccessfulStatusCodes()
            .retryWithAuthIfNeeded()
            .map(Meal.self)
            .catchError { error in
                if let moyaError = error as? MoyaError {
                    return Single.error(NetworkError(moyaError))
                } else {
                    Log.error("Unkown Error!")
                    return Single.error(NetworkError.unknown)
                }
            }
    }
    
    public func getMealPicutre(date: Int) -> Single<MealPicture> {
        provider.rx.request(.mealPicture(date))
            .map(MealPicture.self)
            .catchErrorJustReturn(MealPicture(breakfast: "", lunch: "", dinner: ""))
    }
}
