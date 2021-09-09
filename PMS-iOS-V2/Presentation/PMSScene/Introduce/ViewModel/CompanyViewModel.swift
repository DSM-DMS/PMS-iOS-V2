//
//  CompanyViewModel.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import RxSwift
import RxCocoa
import RxFlow

final public class CompanyViewModel: Stepper {
    public let steps = PublishRelay<Step>()
    private let repository: IntroduceRepository
    private let disposeBag = DisposeBag()
    
    public struct Input {
        let viewDidLoad = PublishRelay<Void>()
        let isLoading = BehaviorRelay<Bool>(value: false)
        let noInternet = PublishRelay<Void>()
        let goDetailClub = PublishRelay<String>()
        let getDetailClub = PublishRelay<String>()
    }
    
    public struct Output {
        let isLoading = BehaviorRelay<Bool>(value: false)
        let clubList = PublishRelay<[Club]>()
        let detailClub = PublishRelay<DetailClub>()
    }
    
    public let input = Input()
    public let output = Output()
    
    public init(repository: IntroduceRepository) {
        self.repository = repository
        let activityIndicator = ActivityIndicator()
        
        input.viewDidLoad
            .asObservable()
            .flatMapLatest { [weak self] _ in
                repository.getClubList()
                    .asObservable()
                    .trackActivity(activityIndicator)
                    .do(onError: { error in
                        let error = error as! NetworkError
                        guard let self = self else { return }
                        self.steps.accept(PMSStep.alert(self.mapError(error: error.rawValue), self.mapError(error: error.rawValue)))
                    })
            }
            .map { $0.clubs }
            .bind(to: output.clubList)
            .disposed(by: disposeBag)
        
        input.noInternet
            .subscribe(onNext: { [weak self] _ in
                self?.steps.accept(PMSStep.alert(LocalizedString.noInternetErrorMsg.localized, .noInternetErrorMsg))
            })
            .disposed(by: disposeBag)
        
        input.goDetailClub
            .subscribe(onNext: { [weak self] club in
                self?.steps.accept(PMSStep.detailClubIsRequired(name: club))
            })
            .disposed(by: disposeBag)
        
        input.getDetailClub
            .asObservable()
            .flatMapLatest { [weak self] club in
                repository.getDetailClub(name: club)
                    .asObservable()
                    .trackActivity(activityIndicator)
                    .do(onError: { error in
                        let error = error as! NetworkError
                        guard let self = self else { return }
                        self.steps.accept(PMSStep.alert(self.mapError(error: error.rawValue), self.mapError(error: error.rawValue)))
                    })
            }
            .bind(to: output.detailClub)
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
