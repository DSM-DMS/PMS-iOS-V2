//
//  RegisterViewModel.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import RxSwift
import RxCocoa
import RxFlow

final public class RegisterViewModel: Stepper {
    public let steps = PublishRelay<Step>()
    @Inject private var repository: RegisterRepository
    private var disposeBag = DisposeBag()
    
    public struct Input {
        let noInternet = PublishRelay<Void>()
        let nicknameText = BehaviorRelay<String>(value: "")
        let emailText = BehaviorRelay<String>(value: "")
        let passwordText = BehaviorRelay<String>(value: "")
        let rePasswordText = BehaviorRelay<String>(value: "")
        let eyeButtonTapped = PublishRelay<Void>()
        let registerButtonTapped = PublishRelay<Void>()
        let facebookRegisterSuccess = PublishRelay<String>()
        let naverRegisterSuccess = PublishRelay<String>()
        let kakaotalkRegisterSuccess = PublishRelay<String>()
        let appleRegisterSuccess = PublishRelay<String>()
        let oAuthError = PublishRelay<Error>()
    }
    
    public struct Output {
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
    
    public let input = Input()
    public let output = Output()
    
    public init() {
        let activityIndicator = ActivityIndicator()
        
        input.noInternet
            .subscribe(onNext: { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.steps.accept(PMSStep.alert(LocalizedString.noInternetErrorMsg.localized, .noInternetErrorMsg))
                }
            })
            .disposed(by: disposeBag)
        
        input.nicknameText
            .map { $0.isNotEmpty() }
            .bind(to: output.isNicknameTyping)
            .disposed(by: disposeBag)
        
        input.nicknameText
            .distinctUntilChanged()
            .map { $0.isNotEmpty() }
            .bind(to: output.isNicknameValid)
            .disposed(by: disposeBag)
        
        input.emailText
            .distinctUntilChanged()
            .map { $0.isEmail() }
            .bind(to: output.isEmailValid)
            .disposed(by: disposeBag)
        
        input.passwordText
            .distinctUntilChanged()
            .map { $0.isNotEmpty() }
            .bind(to: output.isPasswordValid)
            .disposed(by: disposeBag)
        
        input.emailText
            .map { $0.isNotEmpty() }
            .bind(to: output.isEmailTyping)
            .disposed(by: disposeBag)
        
        input.passwordText
            .map { $0.isNotEmpty() }
            .bind(to: output.isPasswordTyping)
            .disposed(by: disposeBag)
        
        input.passwordText
            .map { $0.isNotEmpty() }
            .bind(to: output.passwordEyeVisiable)
            .disposed(by: disposeBag)
        
        input.rePasswordText
            .map { $0.isNotEmpty() }
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
            .map {  AnalyticsManager.click_signUp.log() }
            .flatMap { [weak self] _ -> Observable<Bool> in
                guard let self = self else {
                    return Observable.just(false)
                }
                
                return self.repository.register(name: self.input.nicknameText.value, email: self.input.emailText.value, password: self.input.passwordText.value)
                    .trackActivity(activityIndicator)
                    .do(onError: { error in
                        let error = error as! NetworkError
                        self.steps.accept(PMSStep.alert(self.mapError(error: error.rawValue), self.mapError(error: error.rawValue)))
                    })
                    .catchErrorJustReturn(false)
            }
            .subscribe(onNext: { [weak self] bool in
                if bool {
                    self?.steps.accept(PMSStep.success(.registerSuccessMsg))
                    self?.steps.accept(PMSStep.tabBarIsRequired)
                }
            })
            .disposed(by: disposeBag)
        
        input.facebookRegisterSuccess
            .asObservable()
            .flatMap { [weak self] token -> Observable<Bool> in
                guard let self = self else { return Observable.just(false) }
                
                return self.repository.sendFacebookToken(token: token)
                    .trackActivity(activityIndicator)
                    .do(onError: { error in
                        let error = error as! NetworkError
                        self.steps.accept(PMSStep.alert(self.mapError(error: error.rawValue), self.mapError(error: error.rawValue)))
                    })
                    .catchErrorJustReturn(false)
            }
            .subscribe(onNext: { _ in })
            .disposed(by: disposeBag)
        
        input.naverRegisterSuccess
            .asObservable()
            .flatMap { [weak self] token -> Observable<Bool> in
                guard let self = self else { return Observable.just(false) }
                
                return self.repository.sendNaverToken(token: token)
                    .trackActivity(activityIndicator)
                    .do(onError: { error in
                        let error = error as! NetworkError
                        self.steps.accept(PMSStep.alert(self.mapError(error: error.rawValue), self.mapError(error: error.rawValue)))
                    })
                    .catchErrorJustReturn(false)
            }
            .subscribe(onNext: { _ in })
            .disposed(by: disposeBag)
        
        input.kakaotalkRegisterSuccess
            .asObservable()
            .flatMap { [weak self] token -> Observable<Bool> in
                guard let self = self else { return Observable.just(false) }
                
                return self.repository.sendKakaotalkToken(token: token)
                    .trackActivity(activityIndicator)
                    .do(onError: { error in
                        let error = error as! NetworkError
                        self.steps.accept(PMSStep.alert(self.mapError(error: error.rawValue), self.mapError(error: error.rawValue)))
                    })
                    .catchErrorJustReturn(false)
            }
            .subscribe(onNext: { _ in })
            .disposed(by: disposeBag)
        
        input.appleRegisterSuccess
            .asObservable()
            .flatMap { [weak self] token -> Observable<Bool> in
                guard let self = self else { return Observable.just(false) }
                
                return self.repository.sendKakaotalkToken(token: token)
                    .trackActivity(activityIndicator)
                    .do(onError: { error in
                        let error = error as! NetworkError
                        self.steps.accept(PMSStep.alert(self.mapError(error: error.rawValue), self.mapError(error: error.rawValue)))
                    })
                    .catchErrorJustReturn(false)
            }
            .subscribe(onNext: { [weak self] bool in
                if bool {
                    self?.steps.accept(PMSStep.success(.registerSuccessMsg))
                    self?.steps.accept(PMSStep.tabBarIsRequired)
                }
            })
            .disposed(by: disposeBag)
        
        input.oAuthError
            .subscribe(onNext: { [weak self] error in
                self?.steps.accept(PMSStep.alert(error.localizedDescription, .unknownErrorMsg))
            }).disposed(by: disposeBag)
        
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
