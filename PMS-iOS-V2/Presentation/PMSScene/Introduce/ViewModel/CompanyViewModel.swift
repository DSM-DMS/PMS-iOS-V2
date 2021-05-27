//
//  CompanyViewModel.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import RxSwift
import RxCocoa
import RxFlow

class CompanyViewModel: Stepper {
    let steps = PublishRelay<Step>()
    private let clubRepository: IntroduceRepository
    private let disposeBag = DisposeBag()
    
    struct Input {
        let viewDidLoad = PublishRelay<Void>()
        let isLoading = BehaviorRelay<Bool>(value: false)
        let noInternet = PublishRelay<Void>()
    }
    
    struct Output {
        let isLoading = BehaviorRelay<Bool>(value: false)
        let clubList = PublishRelay<[Club]>()
    }
    
    let input = Input()
    let output = Output()
    
    init(clubRepository: IntroduceRepository) {
        self.clubRepository = clubRepository
        let activityIndicator = ActivityIndicator()
        
        //        input.viewDidLoad
        //            .asObservable()
        //            .flatMapLatest { _ in
        //                clubRepository.getClubList()
        //                    .asObservable()
        //                    .trackActivity(activityIndicator)
        //                    .do(onError: { error in
        //                        let error = error as! NetworkError
        //                        self.steps.accept(PMSStep.alert(self.mapError(error: error.rawValue), self.mapError(error: error.rawValue)))
        //                    })
        //            }
        //            .map { $0.clubs }
        //            .bind(to: output.clubList)
        //            .disposed(by: disposeBag)
        
        input.noInternet
            .subscribe(onNext: { _ in
                self.steps.accept(PMSStep.alert(LocalizedString.noInternetErrorMsg.localized, .noInternetErrorMsg))
                
            })
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
