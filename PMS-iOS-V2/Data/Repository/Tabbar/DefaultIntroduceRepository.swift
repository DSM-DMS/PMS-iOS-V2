//
//  DefaultIntroduceRepository.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import RxSwift
import Moya

final public class DefaultIntroduceRepository: IntroduceRepository {
    private let provider: MoyaProvider<PMSApi>
    
    public init(provider: MoyaProvider<PMSApi>?) {
        self.provider = provider ?? MoyaProvider<PMSApi>()
    }
    
    public func getClubList() -> Single<ClubList> {
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
    
    public func getDetailClub(name: String) -> Single<DetailClub> {
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
    
    public func getDeveloper() -> Single<[Developer]> {
        let developers = [
            Developer(name: "정고은", field: "iOS", image: Asset.ios1.image),
            Developer(name: "강은빈", field: "웹", image: Asset.front1.image),
            Developer(name: "이진우", field: "웹", image: Asset.front2.image),
            Developer(name: "정지우", field: "서버", image: Asset.back1.image),
            Developer(name: "김정빈", field: "서버", image: Asset.back2.image),
            Developer(name: "이은별", field: "안드로이드", image: Asset.android1.image),
            Developer(name: "김재원", field: "안드로이드", image: Asset.android2.image)]
        return Single.just(developers)
    }
}
