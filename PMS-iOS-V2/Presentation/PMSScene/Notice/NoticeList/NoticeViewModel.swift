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
    private let repository: NoticeRepository
    private let disposeBag = DisposeBag()
    private var changeDate = 0
    private var page = 1
    
    public struct Input {
        let viewDidLoad = PublishRelay<Void>()
        let searchText = PublishRelay<String>()
        let previousPageTapped = PublishRelay<Void>()
        let nextPageTapped = PublishRelay<Void>()
        let isLetter = BehaviorRelay<Bool>(value: false)
        let goNoticeDetail = PublishRelay<NoticeCell>()
    }
    
    public struct Output {
        let isLoading = BehaviorRelay<Bool>(value: false)
        let noticeList = PublishRelay<[NoticeCell]>()
        let page = BehaviorRelay<Int>(value: 1)
    }
    
    public let input = Input()
    public let output = Output()
    
    public init(repository: NoticeRepository) {
        self.repository = repository
        let activityIndicator = ActivityIndicator()
        
        input.viewDidLoad
            .map { _ in false }
            .bind(to: input.isLetter)
            .disposed(by: disposeBag)
        
        input.isLetter
            .asObservable()
            .map { if $0 { AnalyticsManager.view_letter.log() } else { AnalyticsManager.view_notice.log() }}
            .flatMapLatest { _ in
                repository.getNoticeList(page: self.page)
                    .asObservable()
                    .trackActivity(activityIndicator)
                    .do(onError: { error in
                        let error = error as! NetworkError
                        self.steps.accept(PMSStep.alert(self.mapError(error: error.rawValue), self.mapError(error: error.rawValue)))
                    })
                    .catchErrorJustReturn([])
            }
            .map { return $0.map { NoticeCell(type: self.input.isLetter.value, notice: $0) }}
            .bind(to: output.noticeList)
            .disposed(by: disposeBag)
        
//        input.searchText
//            .asObservable()
//            .flatMapLatest {
//                noticeRepository.getNoticeList()
//                    .asObservable()
//                    .trackActivity(activityIndicator)
//                    .do(onError: { error in
//                        let error = error as! NetworkError
//                        self.steps.accept(PMSStep.alert(self.mapError(error: error.rawValue), self.mapError(error: error.rawValue)))
//                    })
//                    .catchErrorJustReturn([])
//            }
//            .bind(to: output.noticeList)
//            .disposed(by: disposeBag)
        
        input.previousPageTapped
            .subscribe(onNext: { _ in
                if self.page > 1 {
                    self.page -= 1
                    self.output.page.accept(self.page)
                }
            }).disposed(by: disposeBag)
        
        input.nextPageTapped
            .subscribe(onNext: { _ in
                self.page += 1 // 나중에 최대 페이지 설정하기
                self.output.page.accept(self.page)
            }).disposed(by: disposeBag)
        
        input.goNoticeDetail
            .subscribe {
                self.steps.accept(PMSStep.detailNoticeIsRequired(id: $0.notice.id, title: $0.notice.title))
            }.disposed(by: disposeBag)
        
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
