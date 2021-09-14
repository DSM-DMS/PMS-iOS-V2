//
//  LoginViewModel.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import RxSwift
import RxCocoa
import RxFlow

final public class LoginViewModel: Stepper {
    public let steps = PublishRelay<Step>()
    @Inject private var repository: LoginRepository
    private var disposeBag = DisposeBag()
    
    public struct Input {
        let noInternet = PublishRelay<Void>()
        let emailText = BehaviorRelay<String>(value: "")
        let passwordText = BehaviorRelay<String>(value: "")
        let eyeButtonTapped = PublishRelay<Void>()
        let facebookLoginSuccess = PublishRelay<String>()
        let naverLoginSuccess = PublishRelay<String>()
        let kakaotalkLoginSuccess = PublishRelay<String>()
        let appleLoginSuccess = PublishRelay<String>()
        let loginButtonTapped = PublishRelay<Void>()
        let oAuthError = PublishRelay<Error>()
    }
    
    public struct Output {
        let isLoading = BehaviorRelay<Bool>(value: false)
        let isEmailValid = BehaviorRelay<Bool>(value: false)
        let isEmailTyping = PublishRelay<Bool>()
        let isPasswordTyping = PublishRelay<Bool>()
        let isPasswordValid = BehaviorRelay<Bool>(value: false)
        let isPasswordEyed = BehaviorRelay<Bool>(value: false)
        let passwordEyeVisiable = BehaviorRelay<Bool>(value: false)
        let loginButtonIsEnable = BehaviorRelay<Bool>(value: false)
    }
    
    public let input = Input()
    public let output = Output()
    
    public init() {
        let activityIndicator = ActivityIndicator()
        
        input.noInternet
            .subscribe(onNext: { [weak self] _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self?.steps.accept(PMSStep.alert(LocalizedString.noInternetErrorMsg.localized, .noInternetErrorMsg))
                }
            })
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
            .map {  AnalyticsManager.click_signIn.log() }
            .flatMap { [weak self] _ -> Observable<Bool> in
                guard let self = self else {
                    return Observable.just(false)
                }
                
                return self.repository.login(email: self.input.emailText.value,
                                 password: self.input.passwordText.value)
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
        
        input.facebookLoginSuccess
            .asObservable()
            .flatMap { [weak self] token -> Observable<Bool> in
                guard let self = self else {
                    return Observable.just(false)
                }
                
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
        
        input.naverLoginSuccess
            .asObservable()
            .flatMap { [weak self] token -> Observable<Bool> in
                guard let self = self else {
                    return Observable.just(false)
                }
                
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
        
        input.kakaotalkLoginSuccess
            .asObservable()
            .flatMap { [weak self] token -> Observable<Bool> in
                guard let self = self else {
                    return Observable.just(false)
                }
                
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
        
        input.appleLoginSuccess
            .asObservable()
            .flatMap { [weak self] token -> Observable<Bool> in
                guard let self = self else {
                    return Observable.just(false)
                }
                
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
