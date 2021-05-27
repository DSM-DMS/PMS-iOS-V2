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
    
    func getDeveloper() -> Single<[Developer]> {
        let developers = [Developer("정고은", "iOS", Asset.ios1.image), Developer("강은빈", "웹", Asset.front1.image), Developer("이진우", "웹", Asset.front2.image), Developer("정지우", "서버", Asset.back1.image), Developer("김정빈", "서버", Asset.back2.image), Developer("이은별", "안드로이드", Asset.android1.image), Developer("김재원", "안드로이드", Asset.android2.image)]
        return Single.just(developers)
    }
}
