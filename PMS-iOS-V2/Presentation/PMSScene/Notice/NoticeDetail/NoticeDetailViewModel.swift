//
//  NoticeDetailViewModel.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/25.
//

import RxSwift
import RxCocoa
import RxFlow

class NoticeDetailViewModel: Stepper {
    let steps = PublishRelay<Step>()
    private let id: Int
    let title: String
    private let repository: NoticeRepository
    private let disposeBag = DisposeBag()
    
    struct Input {
        let viewDidLoad = PublishRelay<Void>()
        let noInternet = PublishRelay<Void>()
        let isLoading = BehaviorRelay<Bool>(value: false)
        let commentText = PublishRelay<String>()
        let previewButtonTapped = PublishRelay<Void>()
        let enterButtonTapped = PublishRelay<Void>()
    }
    
    struct Output {
        let isLoading = BehaviorRelay<Bool>(value: false)
        let detailNotice = BehaviorRelay<DetailNotice>(value: DetailNotice(id: 0, date: "", title: "", body: "", comment: [Comment]()))
    }
    
    let input = Input()
    let output = Output()
    
    init(id: Int, title: String, repository: NoticeRepository) {
        self.id = id
        self.title = title
        self.repository = repository
        let activityIndicator = ActivityIndicator()
        
        input.viewDidLoad
            .asObservable()
            .flatMapLatest { _ in
                repository.getDetailNotice(id: self.id)
                    .asObservable()
                    .trackActivity(activityIndicator)
                    .do(onError: { error in
                        let error = error as! NetworkError
                        self.steps.accept(PMSStep.alert(self.mapError(error: error.rawValue), self.mapError(error: error.rawValue)))
                    })
            }
            .bind(to: output.detailNotice)
            .disposed(by: disposeBag)
        
        input.noInternet
            .subscribe(onNext: { _ in
                self.steps.accept(PMSStep.alert(LocalizedString.noInternetErrorMsg.localized, .noInternetErrorMsg))
            })
            .disposed(by: disposeBag)
        
        input.enterButtonTapped
            .subscribe { _ in
                
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
