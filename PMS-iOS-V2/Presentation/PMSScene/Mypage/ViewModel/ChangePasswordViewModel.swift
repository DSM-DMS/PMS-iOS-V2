//
//  ChangePasswordViewModel.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import RxSwift
import RxCocoa
import RxFlow

final public class ChangePasswordViewModel: Stepper {
    public let steps = PublishRelay<Step>()
    @Inject private var repository: ChangePasswordRepository
    private var disposeBag = DisposeBag()
    
    public struct Input {
        let noInternet = PublishRelay<Void>()
        let nowPasswordText = BehaviorRelay<String>(value: "")
        let newPasswordText = BehaviorRelay<String>(value: "")
        let reNewPasswordText = BehaviorRelay<String>(value: "")
        let nowPasswordEyeButtonTapped = PublishRelay<Void>()
        let newPasswordEyeButtonTapped = PublishRelay<Void>()
        let changePasswordButtonTapped = PublishRelay<Void>()
    }
    
    public struct Output {
        let isLoading = BehaviorRelay<Bool>(value: false)
        let isNowPasswordTyping = PublishRelay<Bool>()
        let isNowPasswordValid = BehaviorRelay<Bool>(value: false)
        let isNowPasswordEyed = BehaviorRelay<Bool>(value: false)
        let isNewPasswordTyping = PublishRelay<Bool>()
        let isNewPasswordValid = BehaviorRelay<Bool>(value: false)
        let isNewPasswordEyed = BehaviorRelay<Bool>(value: false)
        let isReNewPasswordValid = BehaviorRelay<Bool>(value: false)
        let isReNewPasswordValidMsg = BehaviorRelay<String>(value: "")
        let isReNewPasswordTyping = PublishRelay<Bool>()
        let nowPasswordEyeVisiable = BehaviorRelay<Bool>(value: false)
        let newPasswordEyeVisiable = BehaviorRelay<Bool>(value: false)
        let changePasswordButtonIsEnable = BehaviorRelay<Bool>(value: false)
    }
    
    public let input = Input()
    public let output = Output()
    
    public init() {
        let activityIndicator = ActivityIndicator()
        
        input.noInternet
            .subscribe(onNext: { [weak self] _ in
                self?.steps.accept(PMSStep.alert(LocalizedString.noInternetErrorMsg.localized, .noInternetErrorMsg))
                
            })
            .disposed(by: disposeBag)
        
        input.nowPasswordText
            .map { if $0.count > 0 { return true } else { return false }}
            .bind(to: output.isNowPasswordValid)
            .disposed(by: disposeBag)
        
        input.nowPasswordText
            .map { if $0.count > 0 { return true } else { return false }}
            .bind(to: output.isNowPasswordTyping)
            .disposed(by: disposeBag)
        
        input.nowPasswordText
            .map { if $0.count > 0 { return true } else { return false }}
            .bind(to: output.isNewPasswordValid)
            .disposed(by: disposeBag)
        
        input.newPasswordText
            .map { if $0.count > 0 { return true } else { return false } }
            .bind(to: output.isNewPasswordTyping)
            .disposed(by: disposeBag)
        
        input.nowPasswordText
            .map { if $0.count > 0 { return true } else { return false } }
            .bind(to: output.nowPasswordEyeVisiable)
            .disposed(by: disposeBag)
        
        input.newPasswordText
            .map { if $0.count > 0 { return true } else { return false } }
            .bind(to: output.newPasswordEyeVisiable)
            .disposed(by: disposeBag)
        
        input.reNewPasswordText
            .map { if $0.count > 0 { return true } else { return false } }
            .bind(to: output.isReNewPasswordTyping)
            .disposed(by: disposeBag)
        
        PublishRelay<Any>.combineLatest(input.newPasswordText, input.reNewPasswordText)
            .filter { $0 != "" && $1 != "" }
            .map { if $0 == $1 { return true } else { return false } }
            .bind(to: output.isReNewPasswordValid)
            .disposed(by: disposeBag)
        
        PublishRelay<Any>.combineLatest(input.newPasswordText, input.reNewPasswordText)
            .filter { $0 != "" && $1 != ""}
            .map { if $0 == $1 { return "" } else { return LocalizedString.notMatchPasswordErrorMsg.localized } }
            .bind(to: output.isReNewPasswordValidMsg)
            .disposed(by: disposeBag)
        
        PublishRelay<Any>.combineLatest(output.isNowPasswordValid, output.isNewPasswordValid, output.isReNewPasswordValid)
            .map { if $0 == true && $1 == true && $2 == true { return true } else { return false } }
            .bind(to: output.changePasswordButtonIsEnable)
            .disposed(by: disposeBag)
        
        input.nowPasswordEyeButtonTapped
            .map { !self.output.isNowPasswordEyed.value }
            .bind(to: output.isNowPasswordEyed)
            .disposed(by: disposeBag)
        
        input.newPasswordEyeButtonTapped
            .map { !self.output.isNewPasswordEyed.value }
            .bind(to: output.isNewPasswordEyed)
            .disposed(by: disposeBag)
        
        input.changePasswordButtonTapped
            .asObservable()
            .map { AnalyticsManager.click_changePassword.log() }
            .flatMap { [weak self] _ -> Observable<Bool> in
                guard let self = self else { return Observable.just(false) }
                
                return self.repository.changePassword(nowPassword: self.input.nowPasswordText.value,
                                          newPassword: self.input.newPasswordText.value)
                    .trackActivity(activityIndicator)
                    .do(onError: { error in
                        let error = error as! NetworkError
                        self.steps.accept(PMSStep.alert(self.mapError(error: error.rawValue), self.mapError(error: error.rawValue)))
                    })
                    .catchErrorJustReturn(false)
            }
            .subscribe(onNext: {
                if $0 {
                    self.steps.accept(PMSStep.success(.changePasswordSuccessMsg))
                }
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
        } else if error == 403 {
            return LocalizedString.notMatchCurrentPasswordErrorMsg.localized
        } else {
            return LocalizedString.unknownErrorMsg.localized
        }
    }
    
    private  func mapError(error: Int) -> AccessibilityString {
        if error == 1 {
            return .noInternetErrorMsg
        } else if error == 403 {
            return .notMatchCurrentPasswordErrorMsg
        } else {
            return .unknownErrorMsg
        }
    }
}
