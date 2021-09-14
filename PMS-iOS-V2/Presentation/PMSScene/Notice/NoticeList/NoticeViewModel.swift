//
//  NoticeViewModel.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import RxSwift
import RxCocoa
import RxFlow

final public class NoticeViewModel: Stepper {
    public let steps = PublishRelay<Step>()
    @Inject private var repository: NoticeRepository
    private let disposeBag = DisposeBag()
    private var page = 0
    private var totalPage = 0
    
    public struct Input {
        let viewDidLoad = PublishRelay<Void>()
        let searchText = PublishRelay<String>()
        let previousPageTapped = PublishRelay<Void>()
        let nextPageTapped = PublishRelay<Void>()
        let segmentControl = BehaviorRelay<Int>(value: 0)
        let getNotice = PublishRelay<Void>()
        let getLetter = PublishRelay<Void>()
        let getAlbum = PublishRelay<Void>()
        let searchNotice = PublishRelay<String>()
        let searchLetter = PublishRelay<String>()
        let goNoticeDetail = PublishRelay<NoticeCell>()
    }
    
    public struct Output {
        let isLoading = BehaviorRelay<Bool>(value: false)
        let noticeList = PublishRelay<[NoticeCell]>()
        let page = BehaviorRelay<Int>(value: 1)
    }
    
    public let input = Input()
    public let output = Output()
    
    public init() {
        let activityIndicator = ActivityIndicator()
        
        input.viewDidLoad
            .map { [weak self] _ in
                self?.input.segmentControl.value ?? 0
            }
            .bind(to: input.segmentControl)
            .disposed(by: disposeBag)
        
        input.segmentControl
            .asObservable()
            .subscribe(onNext: { [weak self] value in
                switch self?.input.segmentControl.value {
                case 0:
                    AnalyticsManager.view_notice.log()
                    self?.input.getNotice.accept(())
                case 1:
                    AnalyticsManager.view_letter.log()
                    self?.input.getLetter.accept(())
                default:
                    AnalyticsManager.view_album.log()
                    self?.input.getAlbum.accept(())
                }
            })
            .disposed(by: disposeBag)
        
        input.getNotice
            .asObservable()
            .map { _ in AnalyticsManager.view_notice.log() }
            .flatMapLatest { [weak self] _ -> Observable<NoticeList> in
                guard let self = self else {
                    return Observable.just(NoticeList(totalPage: 1, notices: [Notice]()))
                }
                
                return self.repository.getNoticeList(page: self.page)
                    .asObservable()
                    .trackActivity(activityIndicator)
                    .do(onError: { error in
                        let error = error as! NetworkError
                        self.steps.accept(PMSStep.alert(self.mapError(error: error.rawValue), self.mapError(error: error.rawValue)))
                    })
                    .catchErrorJustReturn(NoticeList(totalPage: 1, notices: [Notice]()))
            }
            .map { self.totalPage = $0.totalPage; return $0.notices.map { NoticeCell(type: false, notice: $0) }}
            .bind(to: output.noticeList)
            .disposed(by: disposeBag)
        
        input.getLetter
            .asObservable()
            .map { _ in AnalyticsManager.view_letter.log() }
            .flatMapLatest { [weak self] _ -> Observable<NoticeList> in
                guard let self = self else {
                    return Observable.just(NoticeList(totalPage: 1, notices: [Notice]()))
                }
                
                return self.repository.getLetterList(page: self.page)
                    .asObservable()
                    .trackActivity(activityIndicator)
                    .do(onError: { error in
                        let error = error as! NetworkError
                        self.steps.accept(PMSStep.alert(self.mapError(error: error.rawValue), self.mapError(error: error.rawValue)))
                    })
                    .catchErrorJustReturn(NoticeList(totalPage: 1, notices: [Notice]()))
            }
            .map { self.totalPage = $0.totalPage; return $0.notices.map { NoticeCell(type: true, notice: $0) }}
            .bind(to: output.noticeList)
            .disposed(by: disposeBag)
        
        input.getAlbum
            .asObservable()
            .map { _ in AnalyticsManager.view_album.log() }
            .flatMapLatest { [weak self] _ -> Observable<AlbumList> in
                guard let self = self else {
                    return Observable.just(AlbumList(totalPage: 1, totalLength: 1, albums: [Album]()))
                }
                
                return self.repository.getAlbumList(page: self.page)
                    .asObservable()
                    .trackActivity(activityIndicator)
                    .do(onError: { error in
                        let error = error as! NetworkError
                        self.steps.accept(PMSStep.alert(self.mapError(error: error.rawValue), self.mapError(error: error.rawValue)))
                    })
                    .catchErrorJustReturn(AlbumList(totalPage: 1, totalLength: 1, albums: [Album]()))
            }
            .map { self.totalPage = $0.totalPage; return $0.albums.map { NoticeCell(type: false, notice: Notice(id: $0.id, date: $0.date, title: $0.title)) }}
            .bind(to: output.noticeList)
            .disposed(by: disposeBag)
        
        input.searchText
            .asObservable()
            .subscribe(onNext: { [weak self] str in
                if self?.input.segmentControl.value == 0 { // 가정통신문이면
                    self?.input.searchNotice.accept(str)
                } else if self?.input.segmentControl.value == 1 {
                    self?.input.searchLetter.accept(str)
                }
            })
            .disposed(by: disposeBag)
        
        input.searchNotice
            .asObservable()
            .flatMapLatest { [weak self] text -> Observable<NoticeList> in
                guard let self = self else { return Observable.just(NoticeList(totalPage: 1, notices: [Notice]())) }
                
                return self.repository.searchNotice(search: text)
                    .asObservable()
                    .trackActivity(activityIndicator)
                    .do(onError: { error in
                        let error = error as! NetworkError
                        self.steps.accept(PMSStep.alert(self.mapError(error: error.rawValue), self.mapError(error: error.rawValue)))
                    })
                    .catchErrorJustReturn(NoticeList(totalPage: 1, notices: [Notice]()))
            }
            .map { self.totalPage = $0.totalPage; return $0.notices.map { NoticeCell(type: false, notice: $0) }}
            .bind(to: output.noticeList)
            .disposed(by: disposeBag)
        
        input.searchLetter
            .asObservable()
            .flatMapLatest { [weak self] text -> Observable<NoticeList> in
                guard let self = self else { return Observable.just(NoticeList(totalPage: 1, notices: [Notice]())) }
                
                return self.repository.searchLetter(search: text)
                    .asObservable()
                    .trackActivity(activityIndicator)
                    .do(onError: { error in
                        let error = error as! NetworkError
                        self.steps.accept(PMSStep.alert(self.mapError(error: error.rawValue), self.mapError(error: error.rawValue)))
                    })
                    .catchErrorJustReturn(NoticeList(totalPage: 1, notices: [Notice]()))
            }
            .map { self.totalPage = $0.totalPage; return $0.notices.map { NoticeCell(type: true, notice: $0) }}
            .bind(to: output.noticeList)
            .disposed(by: disposeBag)
        
        input.previousPageTapped
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                if self.page > 0 {
                    self.page -= 1
                    self.output.page.accept(self.page + 1)
                    switch self.input.segmentControl.value {
                    case 0:
                        self.input.getNotice.accept(())
                    case 1:
                        self.input.getLetter.accept(())
                    default:
                        self.input.getAlbum.accept(())
                    }
                }
            }).disposed(by: disposeBag)
        
        input.nextPageTapped
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                if self.page + 1 < self.totalPage {
                    self.page += 1
                    self.output.page.accept(self.page + 1)
                    switch self.input.segmentControl.value {
                    case 0:
                        self.input.getNotice.accept(())
                    case 1:
                        self.input.getLetter.accept(())
                    default:
                        self.input.getAlbum.accept(())
                    }
                }
            }).disposed(by: disposeBag)
        
        input.goNoticeDetail
            .subscribe(onNext: { [weak self] cell in
                guard let self = self else { return }
                
                self.steps.accept(PMSStep.detailNoticeIsRequired(id: cell.notice.id, title: cell.notice.title, segment: self.input.segmentControl.value))
            }).disposed(by: disposeBag)
        
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
