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
    let loginRepository: LoginRepository
    private var disposeBag = DisposeBag()
    
    struct Input {
        let emailText = PublishRelay<String>()
        let passwordText = PublishRelay<String>()
        let facebookButtonTapped = PublishRelay<Void>()
        let naverButtonTapped = PublishRelay<Void>()
        let kakaotalkButtonTapped = PublishRelay<Void>()
        let appleButtonTapped = PublishRelay<Void>()
        let loginButtonTapped = PublishRelay<Void>()
    }
    
    struct Output {
        let isEmailValid = PublishRelay<Bool>()
        let isEmailTyping = PublishRelay<Bool>()
        let isPasswordTyping = PublishRelay<Bool>()
        let passwordEyeVisiable = PublishRelay<Bool>()
        let loginButtonIsEnable = PublishRelay<Bool>()
    }
    
    let input = Input()
    let output = Output()
    
    init(loginRepository: LoginRepository) {
        self.loginRepository = loginRepository
        
        input.emailText
            .map {
                if $0.contains("@") && $0.contains(".") { return true } else { return false }
            }
            .bind(to: output.isEmailValid)
            .disposed(by: disposeBag)
        
        input.emailText
            .filter { $0.count > 0 }.map { _ in true }
            .bind(to: output.isEmailTyping)
            .disposed(by: disposeBag)
        
        input.passwordText
            .filter { $0.count > 0 }.map { _ in true }
            .bind(to: output.isPasswordTyping)
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
    }
}
