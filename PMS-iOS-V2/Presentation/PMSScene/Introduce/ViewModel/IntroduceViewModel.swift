//
//  IntroduceViewModel.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import RxSwift
import RxCocoa
import RxFlow

final public class IntroduceViewModel: Stepper {
    public let steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()
    
    public struct Input {
        let clubButtonTapped = PublishRelay<Void>()
        let companyButtonTapped = PublishRelay<Void>()
        let developerButtonTapped = PublishRelay<Void>()
    }
    
    public let input = Input()
    
    public init() {
        input.clubButtonTapped
            .subscribe { [weak self] _ in
                self?.steps.accept(PMSStep.clubIsRequired)
            }.disposed(by: disposeBag)
        
        input.companyButtonTapped
            .subscribe { [weak self] _ in
                self?.steps.accept(PMSStep.companyIsRequired)
            }.disposed(by: disposeBag)
        
        input.developerButtonTapped
            .subscribe { [weak self] _ in
                self?.steps.accept(PMSStep.developerIsRequired)
            }.disposed(by: disposeBag)
    }
}
