//
//  RegisterViewModel.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import RxSwift
import RxCocoa
import RxFlow

class RegisterViewModel: Stepper {
    let steps = PublishRelay<Step>()
    let repository: RegisterRepository
    private var disposeBag = DisposeBag()
    
    struct Input {
        let noInternet = PublishRelay<Void>()
        let nicknameText = BehaviorRelay<String>(value: "")
        let emailText = BehaviorRelay<String>(value: "")
        let passwordText = BehaviorRelay<String>(value: "")
        let rePasswordText = BehaviorRelay<String>(value: "")
        let eyeButtonTapped = PublishRelay<Void>()
        let facebookButtonTapped = PublishRelay<Void>()
        let naverButtonTapped = PublishRelay<Void>()
        let kakaotalkButtonTapped = PublishRelay<Void>()
        let appleButtonTapped = PublishRelay<Void>()
        let registerButtonTapped = PublishRelay<Void>()
    }
    
    struct Output {
        let isLoading = BehaviorRelay<Bool>(value: false)
        let isNicknameTyping = PublishRelay<Bool>()
        let isNicknameValid = BehaviorRelay<Bool>(value: false)
        let isEmailValid = BehaviorRelay<Bool>(value: false)
        let isEmailTyping = PublishRelay<Bool>()
        let isPasswordTyping = PublishRelay<Bool>()
        let isPasswordValid = BehaviorRelay<Bool>(value: false)
        let isPasswordEyed = BehaviorRelay<Bool>(value: false)
        let isRePasswordValid = PublishRelay<Bool>()
        let isRePasswordValidMsg = BehaviorRelay<String>(value: "")
        let isRePasswordTyping = PublishRelay<Bool>()
        let passwordEyeVisiable = BehaviorRelay<Bool>(value: false)
        let registerButtonIsEnable = BehaviorRelay<Bool>(value: false)
    }
    
    let input = Input()
    let output = Output()
    
    init(repository: RegisterRepository) {
        self.repository = repository
        let activityIndicator = ActivityIndicator()
        
        input.noInternet
            .subscribe(onNext: { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.steps.accept(PMSStep.alert(LocalizedString.noInternetErrorMsg.localized, .noInternetErrorMsg))
                }
            })
            .disposed(by: disposeBag)
        
        input.nicknameText
            .map { if $0.count > 0 { return true } else { return false }}
            .bind(to: output.isNicknameTyping)
            .disposed(by: disposeBag)
        
        input.nicknameText
            .distinctUntilChanged()
            .map { if $0.count > 0 { return true } else { return false }}
            .bind(to: output.isNicknameValid)
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
            .map { if $0.count > 0 { return true } else { return false } }
            .bind(to: output.isEmailTyping)
            .disposed(by: disposeBag)
        
        input.passwordText
            .map { if $0.count > 0 { return true } else { return false } }
            .bind(to: output.isPasswordTyping)
            .disposed(by: disposeBag)
        
        input.passwordText
            .map { if $0.count > 0 { return true } else { return false } }
            .bind(to: output.passwordEyeVisiable)
            .disposed(by: disposeBag)
        
        input.rePasswordText
            .map { if $0.count > 0 { return true } else { return false } }
            .bind(to: output.isRePasswordTyping)
            .disposed(by: disposeBag)
        
        PublishRelay<Any>.combineLatest(input.passwordText, input.rePasswordText)
            .map { if $0 == $1 && $0 != "" && $1 != "" { return true } else { return false } }
            .bind(to: output.isRePasswordValid)
            .disposed(by: disposeBag)
        
        PublishRelay<Any>.combineLatest(input.passwordText, input.rePasswordText)
            .filter { $0 != "" && $1 != ""}
            .map { if $0 == $1 { return "" } else { return LocalizedString.notMatchPasswordErrorMsg.localized } }
            .bind(to: output.isRePasswordValidMsg)
            .disposed(by: disposeBag)
        
        PublishRelay<Any>.combineLatest(output.isNicknameValid, output.isEmailValid, output.isPasswordValid, output.isRePasswordValid)
            .map { if $0 == true && $1 == true && $2 == true && $3 == true { return true } else { return false } }
            .bind(to: output.registerButtonIsEnable)
            .disposed(by: disposeBag)
        
        input.eyeButtonTapped
            .map { !self.output.isPasswordEyed.value }
            .bind(to: output.isPasswordEyed)
            .disposed(by: disposeBag)
        
        input.registerButtonTapped
            .asObservable()
            .flatMap {
                repository.register(name: self.input.nicknameText.value, email: self.input.emailText.value, password: self.input.passwordText.value)
                    .trackActivity(activityIndicator)
                    .do(onError: { error in
                        let error = error as! NetworkError
                        self.steps.accept(PMSStep.alert(self.mapError(error: error.rawValue), self.mapError(error: error.rawValue)))
                    })
                    .catchErrorJustReturn(false)
            }
            .subscribe(onNext: {
                if $0 {
                    self.steps.accept(PMSStep.success(.registerSuccessMsg))
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
        if error == 1 {
            return LocalizedString.noInternetErrorMsg.localized
        } else if error == 409 {
            return LocalizedString.existUserErrorMsg.localized
        } else {
            return LocalizedString.unknownErrorMsg.localized
        }
    }
    
    private  func mapError(error: Int) -> AccessibilityString {
        if error == 1 {
            return .noInternetErrorMsg
        } else if error == 409 {
            return .existUserErrorMsg
        } else {
            return .unknownErrorMsg
        }
    }
}
