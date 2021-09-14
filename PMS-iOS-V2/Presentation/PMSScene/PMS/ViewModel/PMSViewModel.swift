//
//  PMSViewModel.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import RxSwift
import RxCocoa
import RxFlow

final public class PMSViewModel: Stepper {
    public let steps = PublishRelay<Step>()
    @Inject private var repository: LoginRepository
    private var disposeBag = DisposeBag()
    
    public struct Input {
        let loginButtonTapped = PublishRelay<Void>()
        let registerButtonTapped = PublishRelay<Void>()
        let noLoginButtonTapped = PublishRelay<Void>()
    }
    
    public struct Output {
        let isLoading = BehaviorRelay<Bool>(value: false)
    }
    
    public let input = Input()
    public let output = Output()
    
    public init() {
        let activityIndicator = ActivityIndicator()
        
        input.loginButtonTapped
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.steps.accept(PMSStep.loginIsRequired)
            })
            .disposed(by: disposeBag)
        
        input.registerButtonTapped
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.steps.accept(PMSStep.registerIsRequired)
            })
            .disposed(by: disposeBag)
        
        input.noLoginButtonTapped
            .asObservable()
            .flatMap { [weak self] _ -> Observable<Bool> in
                guard let self = self else { return Observable.just(false) }
                
                return self.repository.login(email: Bundle.main.infoDictionary!["Auth Email"] as! String,
                                 password: Bundle.main.infoDictionary!["Auth Password"] as! String)
                    .trackActivity(activityIndicator)
                    .do(onError: { error in
                        let error = error as! NetworkError
                        self.steps.accept(PMSStep.alert(self.mapError(error: error.rawValue), self.mapError(error: error.rawValue)))
                    })
                    .catchErrorJustReturn(false)
            }
            .subscribe(onNext: { [weak self] bool in
                if bool {
                    self?.steps.accept(PMSStep.success(.loginSuccessMsg))
                    self?.steps.accept(PMSStep.tabBarIsRequired)
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
