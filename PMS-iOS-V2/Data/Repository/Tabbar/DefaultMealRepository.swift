//
//  DefaultMealRepository.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import Foundation
import Moya
import RxSwift

final class DefaultMealRepository: MealRepository {
    let provider: MoyaProvider<PMSApi>
    
    init(provider: MoyaProvider<PMSApi>?) {
        self.provider = provider ?? MoyaProvider<PMSApi>()
    }
    
    func getMeal(date: Int) -> Single<Meal> {
        provider.rx.request(.meal(date))
            .filterSuccessfulStatusCodes()
            .map(Meal.self)
            .catchError { error in
                if let moyaError = error as? MoyaError {
                    if moyaError.response?.statusCode == 401 {
                        AuthService.shared.refreshToken()
                        Log.info("Refreshed Token~")
                    }
                    return Single.error(NetworkError(moyaError))
                } else {
                    Log.error("Unkown Error!")
                    return Single.error(NetworkError.unknown)
                }
            }.retry(2)
    }
    
    func getMealPicutre(date: Int) -> Single<MealPicture> {
        provider.rx.request(.mealPicture(date))
            .filterSuccessfulStatusCodes()
            .map(MealPicture.self)
            .catchError { error in
                if let moyaError = error as? MoyaError {
                    if moyaError.response?.statusCode == 401 {
                        AuthService.shared.refreshToken()
                        Log.info("Refreshed Token~")
                    }
                    return Single.error(NetworkError(moyaError))
                } else {
                    Log.error("Unkown Error!")
                    return Single.error(NetworkError.unknown)
                }
            }.retry(2)
    }
}
