//
//  DefaultIntroduceRepository.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import Foundation
import RxSwift
import Moya

final class DefaultIntroduceRepository: IntroduceRepository {
    let provider: MoyaProvider<PMSApi>
    
    init(provider: MoyaProvider<PMSApi>?) {
        self.provider = provider ?? MoyaProvider<PMSApi>()
    }
    
    func getClubList() -> Single<ClubList> {
        provider.rx.request(.clubs)
            .filterSuccessfulStatusCodes()
            .retryWithAuthIfNeeded()
            .map(ClubList.self)
            .catchError { error in
                if let moyaError = error as? MoyaError {
                    return Single.error(NetworkError(moyaError))
                } else {
                    Log.error("Unkown Error!")
                    return Single.error(NetworkError.unknown)
                }
            }
    }
    
    func getDetailClub(name: String) -> Single<DetailClub> {
        provider.rx.request(.clubDetail(name))
            .filterSuccessfulStatusCodes()
            .retryWithAuthIfNeeded()
            .map(DetailClub.self)
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
