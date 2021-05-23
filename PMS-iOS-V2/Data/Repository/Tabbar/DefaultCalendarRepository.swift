//
//  DefaultCalendarRepository.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import Foundation
import Moya
import RxSwift

final class DefaultCalendarRepository: CalendarRepository {
    let provider: MoyaProvider<PMSApi>
    
    init(provider: MoyaProvider<PMSApi>?) {
        self.provider = provider ?? MoyaProvider<PMSApi>()
    }
    
    func getCalendar() -> Single<PMSCalendar> {
        provider.rx.request(.calendar)
            .filterSuccessfulStatusCodes()
            .map(PMSCalendar.self)
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
            }
            .retry(2)
    }
}
