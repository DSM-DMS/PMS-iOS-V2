//
//  PMSViewModel.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import RxSwift
import RxCocoa
import RxFlow

class PMSViewModel: Stepper {
    let steps = PublishRelay<Step>()
    let repository: LoginRepository
    private var disposeBag = DisposeBag()
    
    struct Input {
        let loginButtonTapped = PublishRelay<Void>()
        let registerButtonTapped = PublishRelay<Void>()
        let noLoginButtonTapped = PublishRelay<Void>()
    }
    
    struct Output {
        let isLoading = BehaviorRelay<Bool>(value: false)
    }
    
    let input = Input()
    let output = Output()
    
    init(repository: LoginRepository) {
        self.repository = repository
        let activityIndicator = ActivityIndicator()
        
        input.loginButtonTapped
            .asObservable()
            .subscribe(onNext: { _ in
                self.steps.accept(PMSStep.loginIsRequired)
            })
            .disposed(by: disposeBag)
        
        input.registerButtonTapped
            .asObservable()
            .subscribe(onNext: { _ in
                self.steps.accept(PMSStep.registerIsRequired)
            })
            .disposed(by: disposeBag)
        
        //        input.noLoginButtonTapped
        //            .asObservable()
        //            .subscribe(onNext: { _ in
        //                self.steps.accept(PMSStep.tabBarIsRequired)
        //            })
        //            .disposed(by: disposeBag)
        
        input.noLoginButtonTapped
            .asObservable()
            .flatMap {
                repository.login(email: Bundle.main.infoDictionary!["Auth Email"] as! String,
                                 password: Bundle.main.infoDictionary!["Auth Password"] as! String)
                    .trackActivity(activityIndicator)
                    .do(onError: { error in
                        let error = error as! NetworkError
                        self.steps.accept(PMSStep.alert(self.mapError(error: error.rawValue), self.mapError(error: error.rawValue)))
                    })
                    .catchErrorJustReturn(false)
            }
            .subscribe(onNext: {
                if $0 {
                    self.steps.accept(PMSStep.success(.loginSuccessMsg))
                    self.steps.accept(PMSStep.tabBarIsRequired)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func mapError(error: Int) -> String {
        if error == 1 {
            return LocalizedString.noInternetErrorMsg.localized
        } else {
            return LocalizedString.unknownErrorMsg.localized
        }
    }
    
    private func mapError(error: Int) -> AccessibilityString {
        if error == 1 {
            return .noInternetErrorMsg
        } else {
            return .unknownErrorMsg
        }
    }
}
