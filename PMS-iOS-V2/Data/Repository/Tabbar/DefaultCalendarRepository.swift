//
//  DefaultCalendarRepository.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import Moya
import RxSwift

final public class DefaultCalendarRepository: CalendarRepository {
    private let provider: MoyaProvider<PMSApi>
    
    public init(provider: MoyaProvider<PMSApi>?) {
        self.provider = provider ?? MoyaProvider<PMSApi>()
    }
    
    public func getCalendar() -> Single<PMSCalendar> {
        provider.rx.request(.calendar)
            .filterSuccessfulStatusCodes()
            .retryWithAuthIfNeeded()
            .map(PMSCalendar.self)
            .catchError { error in
                if let moyaError = error as? MoyaError {
                    return Single.error(NetworkError(moyaError))
                } else {
                    Log.error("Unkown Error!")
                    return Single.error(NetworkError.unknown)
                }
            }
    }
}
