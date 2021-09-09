//
//  AlbumDetailViewModel.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/08/26.
//

import RxSwift
import RxCocoa
import RxFlow

final public class AlbumDetailViewModel: Stepper {
    public let steps = PublishRelay<Step>()
    private let id: Int
    public let title: String
    private let repository: NoticeRepository
    private let disposeBag = DisposeBag()
    
    public struct Input {
        let viewDidLoad = PublishRelay<Void>()
        let noInternet = PublishRelay<Void>()
        let isLoading = BehaviorRelay<Bool>(value: false)
    }
    
    public struct Output {
        let isLoading = BehaviorRelay<Bool>(value: false)
        let detailNotice = BehaviorRelay<DetailAlbum>(value: DetailAlbum(id: 0, date: "", title: "", body: "", attach: [String](), thumbnail: ""))
    }
    
    public let input = Input()
    public let output = Output()
    
    public init(id: Int, title: String, repository: NoticeRepository) {
        self.id = id
        self.title = title
        self.repository = repository
        let activityIndicator = ActivityIndicator()
        
        input.viewDidLoad
            .asObservable()
            .flatMapLatest { [weak self] _ -> Observable<DetailAlbum> in
                guard let self = self else {
                    return Observable.just(DetailAlbum(id: 0, date: "", title: "", body: "", attach: [String](), thumbnail: ""))
                }
                
                return repository.getDetailAlbum(id: self.id)
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
            .subscribe(onNext: { [weak self] _ in
                self?.steps.accept(PMSStep.alert(LocalizedString.noInternetErrorMsg.localized, .noInternetErrorMsg))
            })
            .disposed(by: disposeBag)
        
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
