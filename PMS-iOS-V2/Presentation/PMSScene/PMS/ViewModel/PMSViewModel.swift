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
    private var disposeBag = DisposeBag()
    
    struct Input {
        let loginButtonTapped = PublishRelay<Void>()
        let registerButtonTapped = PublishRelay<Void>()
        let noLoginButtonTapped = PublishRelay<Void>()
    }
    
    let input = Input()
    
    init() {
        
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
        
        input.noLoginButtonTapped
            .asObservable()
            .subscribe(onNext: { _ in
                self.steps.accept(PMSStep.tabBarIsRequired)
            })
            .disposed(by: disposeBag)
    }
}
