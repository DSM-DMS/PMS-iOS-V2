//
//  LoginViewModel.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import RxSwift
import RxCocoa
import RxFlow

class LoginViewModel: Stepper {
    let steps = PublishRelay<Step>()
    let repository: LoginRepository
    private var disposeBag = DisposeBag()
    
    struct Input {
        let noInternet = PublishRelay<Void>()
        let emailText = BehaviorRelay<String>(value: "")
        let passwordText = BehaviorRelay<String>(value: "")
        let eyeButtonTapped = PublishRelay<Void>()
        let facebookButtonTapped = PublishRelay<Void>()
        let naverButtonTapped = PublishRelay<Void>()
        let kakaotalkButtonTapped = PublishRelay<Void>()
        let appleButtonTapped = PublishRelay<Void>()
        let loginButtonTapped = PublishRelay<Void>()
    }
    
    struct Output {
        let isLoading = BehaviorRelay<Bool>(value: false)
        let isEmailValid = BehaviorRelay<Bool>(value: false)
        let isEmailTyping = PublishRelay<Bool>()
        let isPasswordTyping = PublishRelay<Bool>()
        let isPasswordValid = BehaviorRelay<Bool>(value: false)
        let isPasswordEyed = BehaviorRelay<Bool>(value: false)
        let passwordEyeVisiable = BehaviorRelay<Bool>(value: false)
        let loginButtonIsEnable = BehaviorRelay<Bool>(value: false)
    }
    
    let input = Input()
    let output = Output()
    
    init(repository: LoginRepository) {
        self.repository = repository
        let activityIndicator = ActivityIndicator()
        
        input.noInternet
            .subscribe(onNext: { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.steps.accept(PMSStep.alert(LocalizedString.noInternetErrorMsg.localized, .noInternetErrorMsg))
                }
            })
            .disposed(by: disposeBag)
        
        input.emailText
            .distinctUntilChanged()
            .map {
                if $0.contains("@") && $0.contains(".") { return true } else { return false }
            }
            .bind(to: output.isEmailValid)
            .disposed(by: disposeBag)
        
        input.passwordText
            .distinctUntilChanged()
            .map { if $0.count > 0 { return true } else { return false }}
            .bind(to: output.isPasswordValid)
            .disposed(by: disposeBag)
        
        input.emailText
            .map { if $0.count > 0 { return true} else { return false } }
            .bind(to: output.isEmailTyping)
            .disposed(by: disposeBag)
        
        input.passwordText
            .map { if $0.count > 0 { return true} else { return false } }
            .bind(to: output.isPasswordTyping)
            .disposed(by: disposeBag)
        
        input.passwordText
            .map { if $0.count > 0 { return true} else { return false } }
            .bind(to: output.passwordEyeVisiable)
            .disposed(by: disposeBag)
        
        PublishRelay<Any>.combineLatest(output.isEmailValid, output.isPasswordValid)
            .map { if $0 == true && $1 == true { return true } else { return false } }
            .bind(to: output.loginButtonIsEnable)
            .disposed(by: disposeBag)
        
        input.eyeButtonTapped
            .map { !self.output.isPasswordEyed.value }
            .bind(to: output.isPasswordEyed)
            .disposed(by: disposeBag)
        
        input.loginButtonTapped
            .asObservable()
            .flatMap {
                repository.login(email: self.input.emailText.value,
                                      password: self.input.passwordText.value)
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
        
        input.facebookButtonTapped
            .asObservable()
            .subscribe(onNext: { _ in
                //                self.steps.accept(PMSStep.loginIsRequired)
            })
            .disposed(by: disposeBag)
        
        input.naverButtonTapped
            .asObservable()
            .subscribe(onNext: { _ in
                //                self.steps.accept(PMSStep.registerIsRequired)
            })
            .disposed(by: disposeBag)
        
        input.kakaotalkButtonTapped
            .asObservable()
            .subscribe(onNext: { _ in
                //                self.steps.accept(PMSStep.tabBarIsRequired)
            })
            .disposed(by: disposeBag)
        
        input.appleButtonTapped
            .asObservable()
            .subscribe(onNext: { _ in
                //                self.steps.accept(PMSStep.tabBarIsRequired)
            })
            .disposed(by: disposeBag)
        
        activityIndicator
            .asObservable()
            .bind(to: output.isLoading)
            .disposed(by: disposeBag)
    }
    
    private func mapError(error: Int) -> String {
        if error == 400 || error == 401 {
            return LocalizedString.notFoundUserErrorMsg.localized
        } else if error == 1 {
            return LocalizedString.noInternetErrorMsg.localized
        } else {
            return LocalizedString.unknownErrorMsg.localized
        }
    }
    
    private func mapError(error: Int) -> AccessibilityString {
        if error == 400 || error == 401 {
            return .notFoundUserErrorMsg
        } else if error == 1 {
            return .noInternetErrorMsg
        } else {
            return .unknownErrorMsg
        }
    }
}
