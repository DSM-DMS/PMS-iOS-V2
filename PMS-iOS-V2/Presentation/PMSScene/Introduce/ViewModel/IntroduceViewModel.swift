//
//  IntroduceViewModel.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import RxSwift
import RxCocoa
import RxFlow

class IntroduceViewModel: Stepper {
    let steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()
    
    struct Input {
        let clubButtonTapped = PublishRelay<Void>()
        let companyButtonTapped = PublishRelay<Void>()
        let developerButtonTapped = PublishRelay<Void>()
    }
    
    let input = Input()
    
    init() {
        input.clubButtonTapped
            .subscribe { _ in
                self.steps.accept(PMSStep.clubIsRequired)
            }.disposed(by: disposeBag)
        
        input.companyButtonTapped
            .subscribe { _ in
                self.steps.accept(PMSStep.companyIsRequired)
            }.disposed(by: disposeBag)
        
        input.developerButtonTapped
            .subscribe { _ in
                self.steps.accept(PMSStep.developerIsRequired)
            }.disposed(by: disposeBag)
    }
}
