//
//  DefaultNoticeRepository.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import Moya
import RxSwift

final public class DefaultNoticeRepository: NoticeRepository {
    private let provider: MoyaProvider<PMSApi>
    
    public init(provider: MoyaProvider<PMSApi>?) {
        self.provider = provider ?? MoyaProvider<PMSApi>()
    }
    
    public func getNoticeList(page: Int) -> Single<NoticeList> {
        provider.rx.request(.notice(page))
            .filterSuccessfulStatusCodes()
            .retryWithAuthIfNeeded()
            .map(NoticeList.self)
            .catchError { error in
                if let moyaError = error as? MoyaError {
                    return Single.error(NetworkError(moyaError))
                } else {
                    Log.error("Unkown Error!")
                    return Single.error(NetworkError.unknown)
                }
            }
    }
    
    public func getDetailNotice(id: Int) -> Single<DetailNotice> {
        provider.rx.request(.noticeDetail(id))
            .filterSuccessfulStatusCodes()
            .retryWithAuthIfNeeded()
            .map(DetailNotice.self)
            .catchError { error in
                if let moyaError = error as? MoyaError {
                    return Single.error(NetworkError(moyaError))
                } else {
                    Log.error("Unkown Error!")
                    return Single.error(NetworkError.unknown)
                }
            }
    }
    
    public func searchNotice(search: String) -> Single<NoticeList> {
        provider.rx.request(.searchNotice(search))
            .filterSuccessfulStatusCodes()
            .retryWithAuthIfNeeded()
            .map(NoticeList.self)
            .catchError { error in
                if let moyaError = error as? MoyaError {
                    return Single.error(NetworkError(moyaError))
                } else {
                    Log.error("Unkown Error!")
                    return Single.error(NetworkError.unknown)
                }
            }
    }
    
    public func getLetterList(page: Int) -> Single<NoticeList> {
        provider.rx.request(.letter(page))
            .filterSuccessfulStatusCodes()
            .retryWithAuthIfNeeded()
            .map(NoticeList.self)
            .catchError { error in
                if let moyaError = error as? MoyaError {
                    return Single.error(NetworkError(moyaError))
                } else {
                    Log.error("Unkown Error!")
                    return Single.error(NetworkError.unknown)
                }
            }
    }
    
    public func getDetailLetter(id: Int) -> Single<DetailNotice> {
        provider.rx.request(.letterDetail(id))
            .filterSuccessfulStatusCodes()
            .retryWithAuthIfNeeded()
            .map(DetailNotice.self)
            .catchError { error in
                if let moyaError = error as? MoyaError {
                    return Single.error(NetworkError(moyaError))
                } else {
                    Log.error("Unkown Error!")
                    return Single.error(NetworkError.unknown)
                }
            }
    }
    
    public func searchLetter(search: String) -> Single<NoticeList> {
        provider.rx.request(.searchLetter(search))
            .filterSuccessfulStatusCodes()
            .retryWithAuthIfNeeded()
            .map(NoticeList.self)
            .catchError { error in
                if let moyaError = error as? MoyaError {
                    return Single.error(NetworkError(moyaError))
                } else {
                    Log.error("Unkown Error!")
                    return Single.error(NetworkError.unknown)
                }
            }
    }
    
    public func getAlbumList(page: Int) -> Single<AlbumList> {
        provider.rx.request(.album(page))
            .filterSuccessfulStatusCodes()
            .retryWithAuthIfNeeded()
            .map(AlbumList.self)
            .catchError { error in
                if let moyaError = error as? MoyaError {
                    return Single.error(NetworkError(moyaError))
                } else {
                    Log.error("Unkown Error!")
                    return Single.error(NetworkError.unknown)
                }
            }
    }
    
    public func getDetailAlbum(id: Int) -> Single<DetailAlbum> {
        provider.rx.request(.albumDetail(id))
            .filterSuccessfulStatusCodes()
            .retryWithAuthIfNeeded()
            .map(DetailAlbumResponse.self)
            .map { $0.gallery }
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
